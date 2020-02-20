require "json"
require "./_handler"
require "../models/location"
require "../views/location"
require "../views/city"

module Pilbear::Handlers

  class LocationHandler < PilbearHandler

    def list(context)
      Views::Location.query
        .where { sql("locations.created_by_id = %s", [context.get("user_id").as(Int32)]) }
        .to_a.to_json
    end

    def get(context)
      locs = Views::Location.query
        .where { sql("locations.id = %s", [context.params.url["id"]]) }
        .to_a
      return not_found(context, "Location not found") if locs.size == 0
      locs[0].to_json
    end

    def search_city(context)
      return ([] of String).to_json if !context.params.query["q"]
      q = "%#{context.params.query["q"]}%"
      Views::City.query
        .where { sql("cities.label ILIKE %s OR countries.label ILIKE %s", [q, q]) }
        .limit(20).to_a.to_json
    end

    def create(context)
      missing_fields = validate_body(context, [
        {"label", nil},
        {"description", nil},
        {"lat", nil},
        {"lng", nil},
        {"city_id", nil},
        {"google_id", nil},
      ])
      return invalid_query(context, "Missing field(s): #{missing_fields}") if missing_fields.size > 0
      return not_found(context, "City not found") unless Models::City.where {_id == context.params.json["city_id"].as(Int64)}.exists?
      loc = Models::Location.create({
        label: context.params.json["label"],
        description: context.params.json["description"],
        lat: context.params.json["lat"].as(Float64),
        lng: context.params.json["lng"].as(Float64),
        city_id: context.params.json["city_id"].as(Int64).to_i,
        google_id: context.params.json["google_id"],
        created_by_id: context.get("user_id"),
      })
      Views::Location.query
        .where { sql("locations.id = %s", [loc.id]) }
        .to_a[0].to_json
    end

    def edit(context)
      locs = Models::Location.all.where { sql("locations.id = %s", [context.params.url["id"]]) }.to_a
      return not_found(context, "Location not found") if locs.size == 0
      loc = locs[0]
      loc.label = context.params.json["label"].as(String) if context.params.json.has_key?("label")
      loc.description = context.params.json["description"].as(String) if context.params.json.has_key?("description")
      loc.lat = context.params.json["lat"].as(Float64) if context.params.json.has_key?("lat")
      loc.lng = context.params.json["lng"].as(Float64) if context.params.json.has_key?("lng")
      loc.google_id = context.params.json["google_id"].as(String) if context.params.json.has_key?("google_id")
      if context.params.json["city_id"]
        return not_found(context, "City not found") unless Models::City.where {_id == context.params.json["city_id"].as(Int64)}.exists?
        loc.city_id = context.params.json["city_id"].as(Int64).to_i
      end
      loc.save
      Views::Location.query
        .where { sql("locations.id = %s", [loc.id]) }
        .to_a[0].to_json
    end

  end

end
