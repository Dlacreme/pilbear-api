require "kemal"
require "./const"
require "./middlewares/api"
require "./middlewares/db"
require "./middlewares/auth"
require "./middlewares/password_hash"
require "./middlewares/public_route"

###
# ## Set up Kemal to run as a web API
###
module Pilbear::Setup
  extend self

  def validate_env
    raise "PILBEAR_SECRET is missing" if ENV[Const::Env::SECRET] == nil
  end

  def middleware
    # Run kemal as an API
    add_handler Pilbear::Middlewares::APIMiddleware.new
    # Cryspt potential password
    add_handler Pilbear::Middlewares::PasswordHash.new
    # Provide easy access to our database
    add_handler Pilbear::Middlewares::DBMiddleware.new
    # Check user authentication and set CurrentUser
    # add_handler Pilbear::Middlewares::AuthMiddleware.new
    # Allow user to access specific routes
    add_handler Pilbear::Middlewares::PublicRouteMiddleware.new
  end

  def serve_static_file
    static_headers do |response, filepath, filestat|
      if filepath =~ /\.html$/
        response.headers.add("Access-Control-Allow-Origin", "*")
      end
      response.headers.add("Content-Size", filestat.size.to_s)
    end
  end

  def set_kemal_error
    error 404 { {"error": "Not found"}.to_json }
    error 401 { {"error": "Unauthorized"}.to_json }
    error 500 { {"error": "Server error"}.to_json }
  end
end
