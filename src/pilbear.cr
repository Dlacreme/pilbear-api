require "kemal"
require "kemal-watcher"
require "./setup"
require "./handlers/*"
require "../config/config"

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
  put "/location" { |context| locationHandler.create(context) }
  post "/location/:id" { |context| locationHandler.edit(context) }
  # Event
  get "/event/mine" { |context| eventHandler.list_mine(context) }
  get "/event/user/:id" { |context| eventHandler.list_user(context) }
  get "/event" { |context| eventHandler.list_around(context) }
  get "/event/:id" { |context| eventHandler.get(context) }
  put "/event" { |context| eventHandler.create(context) }
  post "/event/:id" { |context| eventHandler.edit(context) }
  delete "/event/:id" { |context| eventHandler.disable(context) }
  put "/event/:id/join" { |context| eventHandler.join(context) }
  delete "/event/:id/join" { |context| eventHandler.leave(context) }

  Kemal.run

end
