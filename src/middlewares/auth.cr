###
### Make sure users are logged in
###

module Pilbear::Middlewares

  class AuthMiddleware < Kemal::Handler

    def call(context)
      call_next context
    end

  end

end
