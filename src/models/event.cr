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
      confidentiality: {type: String, converter: Jennifer::Model::EnumConverter },
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

    belongs_to :location, Location
    belongs_to :category, Category
    has_many :members, EventUser

    def full?() : Bool
      EventUser.all.where { _event_id == self.id }.to_a.size >= self.capacity
    end

    def join(user : User, role = "member")
      return if EventUser.where { _user_id == user.id && _event_id == self.id }.to_a.size >= 1
      EventUser.create({
        user_id: user.id,
        event_id: self.id,
        event_user_role: role,
      })
    end

    def leave(user : User)
      eu = EventUser.all.where { _user_id == user.id && _event_id == self.id }.to_a
      return if eu.size == 0
      eu.each { |x| EventUser.delete(x.id) }
    end

  end
end
