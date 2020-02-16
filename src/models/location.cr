require "jennifer"
require "./city"
require "./user"
require "./event"

module Pilbear::Models
  class Location < Jennifer::Model::Base
    with_timestamps
    mapping(
      id: Primary32,
      label: String,
      description: String,
      lat: Float32,
      lng: Float32,
      city_id: Int32,
      created_by_id: Int32,
      google_id: String,
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :city, City
    belongs_to :created_by, User
    has_many :events, Event
  end
end
