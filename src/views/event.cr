require "./location"
require "../models/user"
require "../models/event"
require "../models/location"

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
      confidentiality: {type: String, converter: Jennifer::Model::EnumConverter },
      is_disabled: Bool,
    )

    JSON.mapping(
      id: Int32?,
      label: String?,
      description: String?,
      capacity: Int32?,
      created_by_id: Int32?,
      start_date: Time?,
      end_date: Time?,
      category_id: String?,
      location_id: Int32?,
      confidentiality: String?,
      is_disabled: Bool?,
      location: {type: Location, nilable: true}
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
      ev = Views::Event.query
        .where { sql("events.id = %s",[id]) }
        .to_a[0]
      ev.location = Views::Location.find!(ev.location_id)
      ev
    end

    def self.find?(id) : Views::Event | Nil
      evs = Views::Event.query
        .where { sql("events.id = %s",[id]) }
        .to_a
      return nil if evs.size == 0
      ev = evs[0]
      ev.location = Views::Location.find!(ev.location_id)
      ev
    end

  end

end
