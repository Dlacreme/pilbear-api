require "../services/jwt"

###
# ## Make sure users are logged in
###

module Pilbear::Middlewares
  class AuthMiddleware < Kemal::Handler
    def call(context)
      return call_next context if context.request.headers.has_key?("Authorization") == false || context.request.headers["Authorization"] == ""
      user_id = Services::JWT.decode(context.request.headers["Authorization"].split(' ')[1])
      return call_next context if user_id.nil?
      context.set("user_id", user_id)
      if !context.params.json.nil?
        context.params.json["created_by_id"] = user_id.as(Int64)
      end
      call_next context
    end
  end
end
