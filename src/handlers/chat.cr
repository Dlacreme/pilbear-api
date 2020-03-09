require "./_handler"

module Pilbear::Handlers
  class CategoryHandler < PilbearHandler
    SOCKETS  = Hash(String, Hash(String, HTTP::WebSocket)).new
    MESSAGES = [] of String

    ws "/chat/:id" do |socket, context|
      # Add the client to SOCKETS list
      id = context.ws_route_lookup.params["id"]
      if SOCKETS.has_key?(id) == false
        SOCKETS.put(id, Hash{"user_id" => 0, "socket" => socket}) { "Something went wrong during socket creation" }
      end

      # First get the last 50 messages for the user who is connecting
      #MESSAGES.each { |mess| socket.send mess }


      # Broadcast each message to all clients
      socket.on_message do |message|
        #MESSAGES.push(message)
        # Parse the message to make it JSON
        # Redirect to the proper method according to the type sent
        SOCKETS[id].each { |socket| socket.send message }
      end

      # Remove clients from the list when it's closed
      socket.on_close do
        SOCKETS[id].delete socket
      end
    end

    # Private Defintion
    private def login(socket : HTTP::WebSocket, id : String)
      # Parse the SOCKETS array, to find the socket unique id and associate the user_id
    end

    private def logout(socket : HTTP::WebSocket, id : String)
      # Remove the socket from the array
    end

    private def message(socket : HTTP::WebSocket, id : String)
      # Get all users from the chat in DB
      # Check the users connected in the socket and the one in DB
      # For all disconnected users, change the status into `message_pending=true`
      # For all connected users, broadcast the message
    end

    private def alert(socket : HTTP::WebSocket, id : String)
      # Get all users from the chat in DB
      # Check the users connected in the socket and the one in DB
      # For all disconnected users, change the status into `message_pending=true`
      # For all connected users, broadcast the message
    end

    private def history(socket : HTTP::WebSocket, id : String)
      # Receive the last chat_id/user_id/created_at and get the last 50 messages after this one
    end
  end
end
