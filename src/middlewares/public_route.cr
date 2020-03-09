module Pilbear::Middlewares
  class PublicRouteMiddleware < Kemal::Handler
    # Add public routes here
    # exclude [

    # ], "GET"
    exclude [
      "/register",
      "/login",
    ], "POST"

    exclude [
      "/chat/*",
    ], "GET"

    # exclude [

    # ], "PUT"
    # exclude [

    # ], "DELETE"

    def call(context)
      return call_next(context) if exclude_match?(context)
      begin
        user_id = context.get("user_id")
        raise "Unauthorized" if user_id == nil
      rescue
        context.response.status_code = 401
        return {"error": "Unauthorized"}.to_json
      end
      call_next context
    end
  end
end
