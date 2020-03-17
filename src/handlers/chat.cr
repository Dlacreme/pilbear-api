require "json"
require "./_handler"
require "../views/chat"
require "../views/chat_user"
require "../views/chat_message"
require "../models/chat_message"

module Pilbear::Handlers
  class CategoryHandler < PilbearHandler
    SOCKETS = Hash(Int32, Array(Views::ChatWebsocketList)).new
    # Hash(String, HTTP::WebSocket | Int32))).new

    ws "/chat/:id" do |socket, context|
      # Add the client to SOCKETS list
      id = context.ws_route_lookup.params["id"].to_i32
      if SOCKETS.has_key?(id) == false
        SOCKETS.put(id, [] of Views::ChatWebsocketList) { "Something went wrong during socket creation" }
      end
      SOCKETS[id].push(Views::ChatWebsocketList.new(0, socket))

      # Broadcast each message to all clients
      socket.on_message do |message|
        # Parse the message to make it JSON
        payload = Views::ChatWebsocket.from_json(message)
        # Redirect to the proper method according to the type sent
        case payload.type
        when "login"
          self.login(socket, id, payload)
        when "logout"
          self.logout(socket, id, payload)
        when "message"
          self.message(id, payload)
        when "alert"
          self.alert(id, payload)
        when "history"
          self.history(socket, id, payload)
        else
        end
      end

      # Remove clients from the list when it's closed
      # socket.on_close do
      #   SOCKETS[id].delete socket
      # end
    end

    # Private Defintion
    private def self.login(socket : HTTP::WebSocket, id : Int32, payload : Views::ChatWebsocket)
      # Parse the SOCKETS array, to find the socket unique id and associate the user_id
      SOCKETS[id].each do |elem|
        if elem.socket.object_id == socket.object_id
          elem.user_id = payload.data.user_id
          # First get the last 50 messages for the user who is connecting
          history = Views::ChatMessage.get(id, 0, 50)
          history.reverse_each { |obj| elem.socket.send CategoryHandler.formatResponse("history",
            Hash{"user_id" => elem.user_id.as(Int32), "message" => obj.message.as(String), "created_at" => obj.created_at.as(Time)}) }
        end
      end
    end

    private def self.logout(socket : HTTP::WebSocket, id : Int32, payload : Views::ChatWebsocket)
      # Remove the socket from the array
      SOCKETS[id].each do |elem|
        if elem.socket.object_id == socket.object_id
          SOCKETS[id].delete elem
        end
      end
    end

    private def self.message(id : Int32, payload : Views::ChatWebsocket)
      # Get all users
      users = self.getLoginLogoutUsers(id)
      # For all disconnected users, change the status into `message_pending=true`
      Views::ChatUser.update(id, users.disconnected) if users.disconnected.size != 0
      # For all connected users, broadcast the message
      users.connected.each do |elem|
        elem.socket.send self.formatResponse("message",
          Hash{"user_id" => elem.user_id, "message" => payload.data.message, "created_at" => payload.data.created_at})
      end
      # Add the message in DB after that
      Models::ChatMessage.create(chat_id: id,
        user_id: payload.data.user_id,
        message: payload.data.message,
        created_at: payload.data.created_at,
        updated_at: payload.data.created_at
      )
    end

    private def self.alert(id : Int32, payload : Views::ChatWebsocket)
      # Get all users
      users = self.getLoginLogoutUsers(id)
      # For all disconnected users, change the status into `message_pending=true`
      Views::ChatUser.update(id, users.disconnected) if users.disconnected.size != 0
      # For all connected users, broadcast the message
      users.connected.each do |elem|
        elem.socket.send self.formatResponse("alert",
          Hash{"user_id" => elem.user_id, "message" => payload.data.message, "created_at" => payload.data.created_at})
      end
    end

    private def self.history(socket : HTTP::WebSocket, id : Int32, payload : Views::ChatWebsocket)
      # Receive the last chat_id/user_id/created_at and get the last 50 messages after this one
      history = Views::ChatMessage.history(id, payload.data.created_at, 0, 50)
      history.reverse_each { |obj| socket.send self.formatResponse("history",
        Hash{"user_id" => obj.user_id.as(Int32), "message" => obj.message.as(String), "created_at" => obj.created_at.as(Time)}) }
    end

    private def self.getLoginLogoutUsers(id : Int32) : Views::LoginLogoutUsers
      # Get all users from the chat in DB
      users = Views::ChatUser.query.where { sql("chat_users.chat_id = %s", [id]) }.to_a
      connectedUsers = [] of Views::ChatWebsocketList
      disconnectedUsers = [] of Int32
      # Check the users connected in the socket and the one in DB
      SOCKETS[id].each do |elem|
        isConnected = false
        users.each do |user|
          if user.user_id == elem.user_id
            connectedUsers.push(elem)
            isConnected = true
            next
          end
        end
        disconnectedUsers.push(elem.user_id) if isConnected == false
      end
      return Views::LoginLogoutUsers.new(connectedUsers, disconnectedUsers)
    end

    def self.formatResponse(type : String, data : Hash(String, String | Int32 | Time)) : String
      Views::ChatWebsocket.new(type,
        Views::ChatWebsocketData.new(data["user_id"].as(Int32), data["message"].as(String), data["created_at"].as(Time))).to_json
    end
  end
end
