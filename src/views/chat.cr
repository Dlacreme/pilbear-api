module Pilbear::Views
  class Chat < Jennifer::View::Base
    mapping(
      id: Primary32,
      event_id: Int32,
      name: String,
      valid_time: Time?,
      deleted: Bool,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32, emit_null: true},
      event_id: {type: Int32, emit_null: true},
      name: {type: String, emit_null: true},
      valid_time: {type: Time?, emit_null: true},
      deleted: {type: Bool, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(Chat)
      Chat.all
        .select(
          "id," \
          "event_id," \
          "name," \
          "valid_time," \
          "deleted," \
          "created_at," \
          "updated_at"
        )
    end

    def self.find!(id) : Array(Chat)
      users = Views::Chat.query
        .where { sql("id = %s", [id]) }
        .to_a[0]
    end

    def self.find?(id) : User | Nil
      users = Views::Chat.query
        .where { sql("id = %s", [id]) }
        .to_a
      return nil if users.size == 0
      users[0]
    end
  end

  class ChatWebsocketData
    JSON.mapping(
      user_id: {type: Int32, emit_null: true},
      message: {type: String, emit_null: false},
      created_at: {type: Time, emit_null: false},
    )
  end

  class ChatWebsocket
    JSON.mapping(
      type: {type: String, emit_null: false},
      data: {type: ChatWebsocketData, emit_null: false},
    )
  end

  class ChatWebsocketList
    property user_id
    property socket

    def initialize(user_id : Int32, socket : HTTP::WebSocket)
      @user_id = user_id
      @socket = socket
    end
  end

  class LoginLogoutUsers
    property connected
    property disconnected

    def initialize(connected : Array(ChatWebsocketList), disconnected : Array(Int32))
      @connected = connected
      @disconnected = disconnected
    end
  end
end
