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
      chat_name: String,
      message_pending: Bool,
      user_nickname: String,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      user_id: {type: Int32, emit_null: true},
      chat_id: {type: Int32, emit_null: true},
      chat_name: {type: String, emit_null: true},
      message_pending: {type: Bool, emit_null: true},
      user_nickname: {type: String, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(ChatUser)
      q = ChatUser.all
        .join(Models::Chat) { Models::Chat._id == ChatUser.chat_id }
        .join(Models::User) { Models::User._id == ChatUser.user_id }
        .join(Models::Profile) { Models::Profile._id == User.profile_id }
        .select(
          "chat_users.id," \
          "chat_users.user_id," \
          "chat_users.chat_id," \
          "chats.name as chat_name," \
          "chat_users.message_pending," \
          "profiles.nickname as user_nickname," \
          "chat_users.created_at," \
          "chat_users.updated_at"
        )
    end

    def self.find!(id) : Array(ChatUser)
      chats = Views::ChatUser.query
        .where { sql("chats.id = %s", [id]) }
        .first
    end

    def self.find?(id) : ChatUser | Nil
      chats = Views::ChatUser.query
        .where { sql("chats.id = %s", [id]) }
        .first?
    end

    def self.update(chatId : Int32, users : Array(Int32))
      ChatUser.where { sql("chat_id = %d AND user_id IN (#{users.merge(",")})", [chatId]) }.update { {:message_pending => true} }
    end
  end
end
