require "./_handler"
require "../views/event"
require "../views/location"
require "../converters"

module Pilbear::Handlers

  class EventHandler < PilbearHandler

    def list_mine(context)
      evs = Views::Event.query
        .where { sql("events.created_by_id = %s", [context.get("user_id").as(Int32)]) }
        .to_a
      with_location(evs).to_json
    end

    def list_user(context)
      evs = Views::Event.query
        .where { sql("events.created_by_id = %s", [context.params.url["id"]]) }
        .to_a
      with_location(evs).to_json
    end

    def list_around(context)
      return invalid_query(context, "Please provide lat and lng parameter") unless (context.params.query.has_key?("lat") && context.params.query.has_key?("lng"))
      perimeter = context.params.query.has_key?("perimeter") ? context.params.query["perimiter"] : 50
      evs = Views::Event.around(Views::Event.with_location(Views::Event.query),
        context.params.query["lat"],
        context.params.query["lng"],
        perimeter).to_a
      with_location(evs).to_json
    end

    def get(context)
      ev = Views::Event.find?(context.params.url["id"])
      return not_found(context, "Event not found") if ev == nil
      ev.to_json
    end

    def create(context)
      missing_fields = validate_body(context, [
        {"label", nil},
        {"description", nil},
        {"capacity", nil},
        {"start_date", nil},
        {"end_date", nil},
        {"category_id", nil},
        {"confidentiality", nil},
        {"location_id", nil},
      ])
      return invalid_query(context, "Missing field(s): #{missing_fields}") if missing_fields.size > 0
      data = context.params.json
      return not_found(context, "Category not found") unless Models::Category.where {_id == data["category_id"].as(String)}.exists?
      return not_found(context, "Location not found") unless Models::Location.where {_id == data["location_id"].as(Int64)}.exists?
      ev = Models::Event.create({
        label: data["label"].as(String),
        description: data["label"].as(String),
        capacity: data["capacity"].as(Int64).to_i,
        created_by_id: context.get("user_id"),
        start_date: Converters::Datetime.from_string(data["start_date"].as(String)),
        end_date: data.has_key?("end_date") ? Converters::Datetime.from_string(data["end_date"].as(String)) : nil,
        category_id: data["category_id"].as(String),
        location_id: data["location_id"].as(Int64).to_i,
        confidentiality: data["confidentiality"].as(String),
        is_disabled: false,
      })
      ev.join(current_user!(context), "admin")
      raise "Could not create event" if ev.id == nil
      Views::Event.find!(ev.id.as(Int32)).to_json
    end

    def edit(context)
      evs = Models::Event.all.where { _id == context.params.url["id"] }.to_a
      return not_found(context, "Event not found") if evs.size == 0
      ev = evs[0]
      d = context.params.json
      ev.label = d["label"].as(String) if d.has_key?("label")
      ev.description = d["description"].as(String) if d.has_key?("description")
      ev.capacity = d["capacity"].as(Int64).to_i if d.has_key?("capacity")
      ev.start_date = Converters::Datetime.from_string(d["start_date"].as(String)) if d.has_key?("start_date")
      ev.end_date = Converters::Datetime.from_string(d["end_date"].as(String)) if d.has_key?("end_date")
      ev.category_id = d["category_id"].as(String) if d.has_key?("category_id")
      ev.location_id = d["location_id"].as(Int64).to_i if d.has_key?("location_id")
      ev.confidentiality = d["confidentiality"].as(String) if d.has_key?("confidentiality")
      ev.save
      Views::Event.find?(context.params.url["id"]).to_json
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
      evs.each { |e| e.location = locs.find { |l|  l.id == e.location_id} }
      evs
    end

    private def with_members(evs : Array(Views::Event)) : Array(Views::Event)
      return evs
      # return evs if evs.size == 0
      # in_query = ""
      # evs.each { |e| in_query += "#{e.id}," }
      # event_users = Views::EventUser.query { sql("event_id IN (#{in_query.chomp(',')})") }.to_a
      # evs.each { |e| e.members = event_users.find { |eu| eu.event_id == e.id } }
    end

  end

end
