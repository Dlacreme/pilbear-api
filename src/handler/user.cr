require "./handler"

#
module Pilbear::Handler

  class UserHandler < PilbearHandler

    def get_me(context)
      not_implemented(context)
    end

    def get(context)
      # puts context.params.url["id"]
      not_implemented(context)
    end

    def search(context)
      # puts context.params.query["q"]
      not_implemented(context)
    end

    def login(context)
      # puts "login in with"
      # puts context.params.json["email"]
      # puts context.params.json["password"]
      not_implemented(context)
    end

    def register(context)
      # puts "register with"
      # puts context.params.json["email"]
      # puts context.params.json["password"]
      not_implemented(context)
    end

  end

end
