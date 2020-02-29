require "kemal"
require "option_parser"
require "./setup"
require "./handlers/*"
require "./models/*"
require "../config/config"

class HTTP::Server::Context
  def current_user_id : Int32
    self.get("user_id").as(Int32)
  end
end

module Pilbear
  VERSION = "0.0.1"

  # Make sure env is properly setup
  Setup.validate_env
  # Open our static folder
  Setup.serve_static_file
  # Add our own middleware
  Setup.middleware
  # Use our customized errors
  Setup.set_kemal_error

  userHandler = Handlers::UserHandler.new
  categoryHandler = Handlers::CategoryHandler.new
  locationHandler = Handlers::LocationHandler.new
  eventHandler = Handlers::EventHandler.new

  # User
  get "/me" { |context| userHandler.get_me(context) }
  get "/user" { |context| userHandler.search(context) }
  get "/user/:id" { |context| userHandler.get(context) }
  post "/login" { |context| userHandler.login(context) }
  post "/register" { |context| userHandler.register(context) }
  # Category
  get "/categories" { |context| categoryHandler.list(context) }
  # Location
  get "/location" { |context| locationHandler.list(context) }
  get "/location/:id" { |context| locationHandler.get(context) }
  get "/city" { |context| locationHandler.search_city(context) }
  post "/location" { |context| locationHandler.create(context) }
  put "/location/:id" { |context| locationHandler.edit(context) }
  # Event
  get "/event/mine" { |context| eventHandler.list_mine(context) }
  get "/event/user/:id" { |context| eventHandler.list_user(context) }
  get "/event" { |context| eventHandler.list_around(context) }
  get "/event/:id" { |context| eventHandler.get(context) }
  post "/event" { |context| eventHandler.create(context) }
  put "/event/:id" { |context| eventHandler.edit(context) }
  delete "/event/:id" { |context| eventHandler.disable(context) }
  post "/event/:id/join" { |context| eventHandler.join(context) }
  delete "/event/:id/join" { |context| eventHandler.leave(context) }

  bind = "0.0.0.0"
  port = 8080

  OptionParser.parse do |opts|
    opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
      port = opt.to_i
    end
  end

  Kemal.run do |config|
    config.bind_tcp bind, port
  end
end
