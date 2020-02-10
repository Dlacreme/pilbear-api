require "kemal"
require "kemal-watcher"
require "./setup"
require "./handler/user"

module Pilbear
  VERSION = "0.0.1"

  # Open our static folder
  Setup.serve_static_file
  # Add our own middleware
  Setup.middleware
  # Use our customized errors
  Setup.set_kemal_error

  userHandler = Handler::UserHandler.new

  # User
  get "/me" { |context| userHandler.get_me(context) }
  get "/user" { |context| userHandler.search(context) }
  get "/user/:id" { |context| userHandler.get(context) }
  post "/login" { |context| userHandler.login(context) }
  post "/register" { |context| userHandler.register(context) }
  # Group

  # Event

  Kemal.run

end
