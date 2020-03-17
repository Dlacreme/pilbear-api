require "jennifer"
require "./user"
require "./event"

module Pilbear::Models

  class EventUser < Jennifer::Model::Base
    with_timestamps

    mapping(
      id: Primary32,
      user_id: Int32,
      event_id: Int32,
      event_user_role: {type: String, converter: Jennifer::Model::EnumConverter},
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :user, User
    belongs_to :event, Event

  end

end
