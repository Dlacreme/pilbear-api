###
### Make sure users are logged in
###

module Pilbear::Middleware

  class AuthMiddleware < Kemal::Handler

    def call(context)
      puts "Auth Middleware"
      call_next context
    end

  end

end
