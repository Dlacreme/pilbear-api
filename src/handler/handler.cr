require "kemal"

module Pilbear::Handler

  class PilbearHandler

    def not_implemented(context)
      context.response.status_code = 521
      {"error": "Not implemented"}.to_json
    end

  end

end
