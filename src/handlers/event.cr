require "./_handler"
require "../views/event"
require "../views/user"
require "../views/location"
require "../converters"

module Pilbear::Handlers
  class EventHandler < PilbearHandler
    def list_mine(context)
      evs = Views::Event.query
        .where { sql("events.created_by_id = %s", [context.get("user_id").to_i]) }
        .to_a
      Views::Event.with_location_and_members(evs).to_json
    end

    def list_user(context)
      evs = Views::Event.query
        .where { sql("events.created_by_id = %s", [context.params.url["id"]]) }
        .to_a
      Views::Event.with_location(evs).to_json
    end

    def list_around(context)
      return invalid_query(context, "Please provide lat and lng parameter") unless (context.params.query.has_key?("lat") && context.params.query.has_key?("lng"))
      perimeter = context.params.query.has_key?("perimeter") ? context.params.query["perimiter"] : 50
      evs = Views::Event.around(Views::Event.with_location(Views::Event.query),
        context.params.query["lat"],
        context.params.query["lng"],
        perimeter).to_a
      Views::Event.with_location(evs).to_json
    end

    def get(context)
      ev = Views::Event.find?(context.params.url["id"])
      return not_found!("Event not found") if ev == nil
      ev.to_json
    end

    def create(context)
      begin
        ev = Models::Event.from_json(body.to_json)
        ev.save
        Views::Event.find!(ev.id).to_json
      rescue ex
        fail_query(context, ex)
      end
    end

    def edit(context)
      ev = Models::Event.all.where { _id == context.params.url["id"] }.to_a.first?
      return not_found(context, "Event not found") if ev.nil?
      ev.update_from_hash(body)
      ev.save
      Views::Event.find!(context.params.url["id"]).to_json
    end

    def disable(context)
      evs = Models::Event.all.where { _id == context.params.url["id"] }.to_a
      return not_found(context, "Event not found") if evs.size == 0
      evs[0].is_disabled = true
      evs[0].save
      ok(context)
    end

    def join(context)
      evs = Models::Event.all.where { sql("id = %s", [context.params.url["id"]]) }.to_a
      return not_found(context, "Event not found") if evs.size == 0
      ev = evs[0]
      return invalid_query(context, "Event is full") if ev.full?
      ev.join(current_user!(context))
      ok(context)
    end

    def leave(context)
      evs = Models::Event.all.where { sql("id = %s", [context.params.url["id"]]) }.to_a
      return not_found(context, "Event not found") if evs.size == 0
      ev = evs[0]
      ev.leave(current_user!(context))
      ok(context)
    end

    private def with_location(evs : Array(Views::Event)) : Array(Views::Event)
      return evs if evs.size == 0
      in_query = ""
      evs.each { |e| in_query += "#{e.location_id}," }
      locs = Views::Location.query
        .where { sql("locations.id IN (#{in_query.chomp(',')})") }
        .to_a
      evs.each { |e| e.location = locs.find { |l| l.id == e.location_id } }
      evs
    end

    private def with_members(evs : Array(Views::Event)) : Array(Views::Event)
      return evs if evs.size == 0
      in_query = ""
      evs.each { |e| in_query += "#{e.id}," }
      event_users = Views::EventUser.all
        .join(Views::User) { Views::EventUser._user_id == Views::User._id }
        .where { sql("event_id IN (#{in_query.chomp(',')})") }
        .to_a
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
  end
end
