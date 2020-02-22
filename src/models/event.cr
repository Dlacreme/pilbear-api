require "jennifer"
require "./location"
require "./category"
require "../converter"

module Pilbear::Models
  class Event < Jennifer::Model::Base
    with_timestamps
    mapping(
      id: Primary32,
      label: String,
      description: String,
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
  end
end
