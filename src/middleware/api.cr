###
### run Kemal as an API
###

module Pilbear::Middleware

  class APIMiddleware < Kemal::Handler

    def call(context)
      context.response.content_type = "application/json"
      call_next context
    end

  end

end
