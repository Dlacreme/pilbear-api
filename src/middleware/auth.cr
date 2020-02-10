###
### Make sure users are logged in
###

module Pilbear::Middleware

  class AuthMiddleware < Kemal::Handler

    def call(context)
      call_next context
    end

  end

end
