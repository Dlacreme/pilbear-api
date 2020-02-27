require "jennifer"
require "./location"
require "./category"
require "./event_user"

module Pilbear::Models
  class Event < Jennifer::Model::Base
    with_timestamps
    mapping(
      id: Primary32,
      label: String,
      description: String,
      confidentiality: {type: String, converter: Jennifer::Model::EnumConverter},
      capacity: Int32,
      created_by_id: Int32,
      start_date: {type: Time},
      end_date: {type: Time?},
      category_id: String,
      location_id: Int32,
      is_disabled: Bool,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: Int32?,
      label: String,
      description: String?,
      confidentiality: {type: String, default: "public"},
      capacity: Int32,
      created_by_id: Int32?,
      start_date: Time,
      end_date: Time?,
      category_id: String,
      location_id: Int32,
      is_disabled: {type: Bool, default: false},
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :location, Location
    belongs_to :category, Category
    has_many :members, EventUser

    def full? : Bool
      EventUser.all.where { _event_id == self.id }.to_a.size >= self.capacity
    end

    def join(user : User, role = "member")
      return if EventUser.where { _user_id == user.id && _event_id == self.id }.to_a.size >= 1
      EventUser.create({
        user_id:         user.id,
        event_id:        self.id,
        event_user_role: role,
      })
    end

    def leave(user : User)
      EventUser.all.where { _user_id == user.id && _event_id == self.id }
        .to_a.each { |x| EventUser.delete(x.id) }
    end

    def update_from_hash(hash : Hash)
      self.label = hash["label"].as(String) if hash.has_key?("label")
      self.description = hash["description"].as(String) if hash.has_key?("description")
      self.capacity = hash["capacity"].as(Int64).to_i if hash.has_key?("capacity")
      self.start_date = Converters::Datetime.from_string(hash["start_date"].as(String)) if hash.has_key?("start_date")
      self.end_date = Converters::Datetime.from_string(hash["end_date"].as(String)) if hash.has_key?("end_date")
      self.category_id = hash["category_id"].as(String) if hash.has_key?("category_id")
      self.location_id = hash["location_id"].as(Int64).to_i if hash.has_key?("location_id")
      self.confidentiality = hash["confidentiality"].as(String) if hash.has_key?("confidentiality")
    end
  end
end
