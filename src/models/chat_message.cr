require "jennifer"
require "./user"
require "./chat"

module Pilbear::Models

  class ChatMessage < Jennifer::Model::Base
    with_timestamps

    mapping(
      id: Primary32,
      message: String,
      chat_id: Int32?,
      user_id: Int32?,
      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :chat, Chat
    belongs_to :users, User
  end

end
