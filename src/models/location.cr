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
      lat: Float64,
      lng: Float64,
      city_id: Int32,
      created_by_id: Int32,
      google_id: String,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: Int32?,
      label: String,
      description: String?,
      lat: Float64,
      lng: Float64,
      city_id: Int32,
      created_by_id: Int32?,
      google_id: String,
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :city, City
    belongs_to :created_by, User
    has_many :events, Event

    def update_from_hash(hash : Hash)
      self.label = hash["label"].as(String) if hash.has_key?("label")
      self.description = hash["description"].as(String) if hash.has_key?("description")
      self.lat = hash["lat"].as(Float64) if hash.has_key?("lat")
      self.lng = hash["lng"].as(Float64) if hash.has_key?("lng")
      self.google_id = hash["google_id"].as(String) if hash.has_key?("google_id")
      if hash.has_key?("city_id")
        self.city_id = hash["city_id"].as(Int64).to_i
        # @city = City.find!(hash["city_id"].as(Int64).to_u)
        # c = City.all.where { sql("cities.id = %s", [hash["city_id"].as(Int64)]) }.to_a.first?
        # puts c
      end
    end
  end
end
