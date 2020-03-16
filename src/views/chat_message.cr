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
      # q = ChatMessage.all
      #   .left_join(Models::Chat) { ChatMessage.chat_id == c("chats.id") }
      #   .left_join(Models::User) { Models::User._id == ChatMessage.user_id }
      #   .left_join(Models::Profile) { Models::Profile._id == User.profile_id }
      #   .select(
      #     "chat_messages.id," \
      #     "user_id," \
      #     "chat_id," \
      #     "chats.name as chat_name," \
      #     "message," \
      #     "profiles.nickname as user_nickname," \
      #     "chat_messages.created_at," \
      #     "chat_messages.updated_at"
      #   )
      q = Jennifer::QueryBuilder::Query.new
        .select("cm.id, cm.user_id, cm.chat_id, c.name as chat_name, cm.message, p.nickname as user_nickname, cm.created_at, cm.updated_at" \
                " FROM chat_messages cm " \
                "LEFT JOIN chats c ON c.id = cm.chat_id " \
                "LEFT JOIN users u ON u.id = cm.user_id " \
                "LEFT JOIN profiles p ON p.id = u.profile_id "
        )
    end

    def self.find!(id) : Array(Jennifer::Record)
      messages = Views::ChatMessage.query
        .where { sql("c.id = %s", [id]) }
        .to_a[0]
    end

    def self.find?(id) : Jennifer::Record | Nil
      messages = Views::ChatMessage.query
        .where { sql("c.id = %s", [id]) }
        .to_a
      return nil if messages.size == 0
      messages[0]
    end

    def self.get(id : Int32, offset : Int32 = 0, limit : Int32 = 50) : Array(Jennifer::Record)
      messages = Views::ChatMessage.query
        .where { sql("c.id = %s", [id]) }
        .order(Hash{"cm.created_at" => "DESC"})
        .limit(limit)
        .offset(offset)
        .to_a
    end

    def self.history(id : Int32, createdAt : Time, offset : Int32 = 0, limit : Int32 = 50) : Array(Jennifer::Record)
      messages = Views::ChatMessage.query
        .where { sql("c.id = %s AND cm.created_at < %s", [id, createdAt]) }
        .order(Hash{"cm.created_at" => "DESC"})
        .limit(limit)
        .offset(offset)
        .to_a
    end
  end
end
