require "json"
require "./_handler"
require "../models/location"
require "../views/location"
require "../views/city"

module Pilbear::Handlers
  class LocationHandler < PilbearHandler
    def list(context)
      puts(typeof(context.params.json))
      Views::Location.query
        .where { sql("locations.created_by_id = %s", [context.get("user_id")]) }
        .to_a.to_json
    end

    def get(context)
      loc = Views::Location.find?(context.params.url["id"])
      return not_found(context, "Location not found") if loc == nil
      loc.to_json
    end

    def search_city(context)
      return ([] of String).to_json if !context.params.query["q"]
      q = "%#{context.params.query["q"]}%"
      Views::City.query
        .where { sql("cities.label ILIKE %s OR countries.label ILIKE %s", [q, q]) }
        .limit(20).to_a.to_json
    end

    def create(context)
      begin
        loc = Models::Location.from_json(body.to_json)
        loc.save
        Views::Location.find!(loc.id).to_json
      rescue ex
        return fail_query(context, ex)
      end
    end

    def edit(context)
      loc = Models::Location.all.where { sql("locations.id = %s", [context.params.url["id"]]) }.to_a.first?
      return not_found(context, "Location not found") if loc.nil?
      begin
        loc.update_from_hash(body)
        puts loc
        loc.save
      rescue ex
        return fail_query(context, ex)
      end
      Views::Location.find!(loc.id).to_json
    end
  end
end
