
module Pilbear::Views

  class Location < Jennifer::View::Base

    mapping(
      id: Primary32,
      label: String,
      description: String,
      lat: Float64,
      lng: Float64,
      google_id: String,
      city_id: Int32,
      country_id: String,
      city: String,
      country: String,
    )

    JSON.mapping(
      id: Int32?,
      label: String?,
      description: String?,
      lat: Float64?,
      lng: Float64?,
      google_id: String?,
      city_id: Int32?,
      country_id: String?,
      city: String?,
      country: String?,
    )

    def self.query() : Jennifer::QueryBuilder::ModelQuery(Location)
      Location.all
        .join(Models::City) { Models::City._id == Models::Location._city_id }
        .join(Models::Country) { Models::Country._id == Models::City._country_id }
        .select(
          "locations.id as id," \
          "locations.label as label," \
          "locations.description as description," \
          "locations.lat as lat," \
          "locations.lng as lng," \
          "locations.google_id as google_id," \
          "locations.city_id as city_id," \
          "cities.country_id as country_id," \
          "cities.label as city," \
          "countries.label as country"
        )
    end

    def self.find!(id) : Location
      Views::Location.query
        .where { sql("locations.id = %s", [id]) }
        .to_a[0]
    end

    def self.find?(id) : Location | Nil
      res = Views::Location.query
        .where { sql("locations.id = %s", [id]) }
        .to_a
      return nil if res.size == 0
      res[0]
    end

  end

end
