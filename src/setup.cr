require "kemal"
require "./middleware/api"
require "./middleware/db"
require "./middleware/auth"

###
### Set up Kemal to run as a web API
###
module Pilbear::Setup

  extend self

  def middleware
    # Run kemal as an API
    add_handler Pilbear::Middleware::APIMiddleware.new
    # Provide easy access to our database
    add_handler Pilbear::Middleware::DBMiddleware.new
    # Check user authentication and set CurrentUser
    add_handler Pilbear::Middleware::AuthMiddleware.new
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
    error 400 { {"error": "Invalid query"}.to_json }
    error 401 { {"error": "Unauthorized"}.to_json }
    error 404 { {"error": "Not found"}.to_json }
    error 501 { {"error": "Server error"}.to_json }
    error 501 { {"error": "Not implemented"}.to_json }
  end

end
