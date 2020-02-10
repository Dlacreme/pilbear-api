require "kemal"
require "kemal-watcher"
require "./setup"

module Pilbear
  VERSION = "0.0.1"

  # Open our static folder
  Pilbear::Setup.serve_static_file
  # Add our own middleware
  Pilbear::Setup.middleware

  get "/" do
    {"Hello": "bite lol"}.to_json
  end

  Kemal.run

end
