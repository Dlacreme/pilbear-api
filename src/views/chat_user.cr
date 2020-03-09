require "./chat"
require "../models/user"
require "../models/chat"
require "../models/profile"

module Pilbear::Views
  class ChatUser < Jennifer::View::Base
    mapping(
      id: Primary32,
      user_id: Int32,
      chat_id: Int32,
      message_pending: Bool,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      user_id: {type: Int32, emit_null: true},
      chat_id: {type: Int32, emit_null: true},
      message_pending: {type: Bool, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true},
      user_nickname: {type: String, emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(ChatUser)
      q = ChatUser.all
        .join(Models::Chat) { Models::Chat._id == ChatUser.chat_id }
        .join(Model::User) { Models::User._id == ChatUser.user_id }
        .join(Models::Profile) { Models::Profile._id == User.profile_id }
        .select(
          "user_id," \
          "chat_id," \
          "chat.name as chat_name," \
          "message_pending," \
          "profiles.nickname as user_nickname"
        )
    end

    def self.find!(id) : Array(ChatUser)
      users = Views::User.query
        .where { sql("users.id = %s", [id]) }
        .to_a[0]
    end

    def self.find?(id) : User | Nil
      users = Views::User.query
        .where { sql("users.id = %s", [id]) }
        .to_a
      return nil if users.size == 0
      users[0]
    end
  end
end
