
module Pilbear::Views

  class City < Jennifer::View::Base

    mapping(
      id: Primary32,
      label: String,
      country_id: String,
      country_label: String,
    )

    JSON.mapping(
      id: Int32?,
      label: String?,
      country_id: String,
      country_label: String?,
    )

    def self.query() : Jennifer::QueryBuilder::ModelQuery(City)
      City.all
        .join(Models::Country) {Models::City._country_id == Models::Country._id}
        .select(
          "cities.id as id," \
          "cities.label as label," \
          "countries.id as country_id," \
          "countries.label as country_label"
        )
    end

  end

end
