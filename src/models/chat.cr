require "jennifer"
require "./event"

module Pilbear::Models

  class Chat < Jennifer::Model::Base
    with_timestamps

    mapping(
      id: Primary32,
      name: String,
      valid_time: Time?,
      deleted: Bool,
      event_id: Int32?,
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :event, Event
  end

end
