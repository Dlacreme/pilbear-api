require "./chat"
require "../models/user"
require "../models/chat"
require "../models/profile"

module Pilbear::Views
  class ChatMessage < Jennifer::View::Base
    mapping(
      id: Primary32,
      chat_id: Int32,
      user_id: Int32,
      chat_name: String,
      message: String,
      user_nickname: String,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      user_id: {type: Int32, emit_null: true},
      chat_id: {type: Int32, emit_null: true},
      chat_name: {type: String, emit_null: true},
      message: {type: String, emit_null: true},
      user_nickname: {type: String, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true}
    )

    def self.query : Jennifer::QueryBuilder::Query
      q = ChatMessage.all
        .left_join(Models::Chat) { Models::Chat._id == ChatMessage._chat_id }
        .left_join(Models::User) { Models::User._id == ChatMessage._user_id }
        .left_join(Models::Profile) { Models::Profile._id == User._profile_id }
        .select(
          "chat_messages.id," \
          "chat_messages.user_id," \
          "chat_messages.chat_id," \
          "chats.name as chat_name," \
          "chat_messages.message," \
          "profiles.nickname as user_nickname," \
          "chat_messages.created_at," \
          "chat_messages.updated_at"
        )
    end

    def self.get(id : Int32, offset : Int32 = 0, limit : Int32 = 50) : Array(ChatMessage)
      messages = Views::ChatMessage.query
        .where { sql("chat_messages.chat_id = %s", [id]) }
        .order(Hash{"chat_messages.created_at" => "DESC"})
        .limit(limit)
        .offset(offset)
        .to_a
    end

    def self.history(id : Int32, createdAt : Time, offset : Int32 = 0, limit : Int32 = 50) : Array(ChatMessage)
      messages = Views::ChatMessage.query
        .where { sql("chat_messages.chat_id = %s AND chat_messages.created_at < %s", [id, createdAt]) }
        .order(Hash{"chat_messages.created_at" => "DESC"})
        .limit(limit)
        .offset(offset)
        .to_a
    end
  end
end
