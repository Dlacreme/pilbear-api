require "jennifer"
require "./user"
require "./event"

module Pilbear::Models

  class ChatUsers < Jennifer::Model::Base
    with_timestamps

    mapping(
      id: Primary32,
      message_pending: Bool,
      chat_id: Int32?,
      user_id: Int32?,
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :chat, Chat
    belongs_to :users, User
  end

end
