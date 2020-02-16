require "crypto/bcrypt"

###
### Insert a DB Instance to our query
###

module Pilbear::Middlewares

  class PasswordHash < Kemal::Handler

    def call(context)
      ## Should check format here
      call_next(context) unless context.params.json.has_key?("password")
      context.params.json["password"] = Crypto::Bcrypt.hash_secret(context.params.json["password"].as(String), 10)
      call_next context
    end

  end

end
