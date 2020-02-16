
require "jennifer"

module Pilbear::Models

  class Country < Jennifer::Model::Base
    mapping(
      id: {type: String, primary: true},
      label: String,
      language_id: String
    )
    belongs_to :language, Language
    has_one :city, City
  end

  class City < Jennifer::Model::Base
    mapping(
      id: {type: UInt32, primary: true},
      label: String,
      country_id: String
    )
    belongs_to :country, Country
  end

  class Language < Jennifer::Model::Base
    mapping(
      id: {type: String, primary: true},
      label: String,
      label_en: String
    )
    has_many :countries, Country
  end

end
