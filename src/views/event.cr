require "./location"
require "./event_user"
require "../models/user"
require "../models/event"
require "../models/location"
require "../models/event_user"

module Pilbear::Views
  class Event < Jennifer::View::Base
    mapping(
      id: Primary32,
      label: String,
      description: String,
      capacity: Int32,
      created_by_id: Int32,
      start_date: Time,
      end_date: Time?,
      category_id: String,
      location_id: Int32,
      confidentiality: {type: String, converter: Jennifer::Model::EnumConverter},
      is_disabled: Bool,
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      label: {type: String?, emit_null: true},
      description: {type: String?, emit_null: true},
      capacity: {type: Int32?, emit_null: true},
      created_by_id: {type: Int32?, emit_null: true},
      start_date: {type: Time?, emit_null: true},
      end_date: {type: Time?, emit_null: true},
      category_id: {type: String?, emit_null: true},
      location_id: {type: Int32?, emit_null: true},
      confidentiality: {type: String?, emit_null: true},
      is_disabled: {type: Bool?, emit_null: true},
      location: {type: Location?, emit_null: true},
      members: {type: Array(EventUser)?, emit_null: true},
    )

    def self.query(show_all : Bool = false) : Jennifer::QueryBuilder::ModelQuery(Event)
      q = Event.all
        .select(
          "events.id as id," \
          "events.label as label," \
          "events.description as description," \
          "events.capacity as capacity," \
          "events.start_date as start_date," \
          "events.end_date as end_date," \
          "events.category_id as category_id," \
          "events.location_id as location_id," \
          "events.is_disabled as is_disabled," \
          "events.confidentiality as confidentiality," \
          "events.created_by_id as created_by_id"
        )
      show_all ? q : active_only(q)
    end

    def self.with_location(q : Jennifer::QueryBuilder::ModelQuery(Event)) : Jennifer::QueryBuilder::ModelQuery(Event)
      q.join(Models::Location) { Models::Location._id == Event._location_id }
    end

    def self.active_only(q : Jennifer::QueryBuilder::ModelQuery(Event)) : Jennifer::QueryBuilder::ModelQuery(Event)
      q.where { sql("events.is_disabled = 'f' AND start_date > %s", [Time.utc]) }
    end

    def self.around(q : Jennifer::QueryBuilder::ModelQuery(Event), lat, lng, perimeter = 50) : Jennifer::QueryBuilder::ModelQuery(Event)
      q.where { sql("calculate_distance(%s, %s, locations.lat, locations.lng, 'K') < %s", [lat, lng, perimeter]) }
    end

    def self.find!(id) : Views::Event
      ev = Views::Event.query(true)
        .where { sql("events.id = %s", [id]) }
        .to_a[0]
      ev.location = Views::Location.find!(ev.location_id)
      ev
    end

    def self.find?(id) : Views::Event | Nil
      evs = Views::Event.query
        .where { sql("events.id = %s", [id]) }
        .to_a
      return nil if evs.size == 0
      ev = evs[0]
      ev.location = Views::Location.find!(ev.location_id)
      ev
    end

    def self.with_location(evs : Array(Event)) : Array(Views::Event)
      return evs if evs.size == 0
      in_query = ""
      evs.each { |e| in_query += "#{e.location_id}," }
      locs = Views::Location.query
        .where { sql("locations.id IN (#{in_query.chomp(',')})") }
        .to_a
      evs.each { |e| e.location = locs.find { |l| l.id == e.location_id } }
      evs
    end

    def self.with_members(evs : Array(Event)) : Array(Views::Event)
      return evs if evs.size == 0
      in_query = ""
      evs.each { |e| in_query += "#{e.id}," }
      event_users = Views::EventUser.all
        .join(Views::User) { Views::EventUser._user_id == Views::User._id }
        .where { sql("event_id IN (#{in_query.chomp(',')})") }
        .to_a
      return evs if event_users.size == 0
      in_query = ""
      event_users.each { |eu| in_query += "#{eu.user_id}," }
      users = Views::User.query.where { sql("users.id IN (#{in_query.chomp(',')})") }.to_a
      event_users.each { |eu| eu.user = users.find { |u| u.id == eu.user_id } }
      evs.each do |e|
        eus = event_users.select { |eu| eu.event_id == e.id }
        e.members = eus != nil ? eus : [] of Views::EventUser
      end
      evs
    end

    def self.with_location_and_members(evs : Array(Event)) : Array(Views::Event)
      with_members(with_location(evs))
    end
  end
end
