require "./_handler"
require "../const"
require "../models/user"

#
module Pilbear::Handlers

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
      missing_fields = validate_body(context, [
        {"email", Const::Regex::EMAIL},
        {"password", nil}
      ])
      return invalid_query(context, "Missing field(s): #{missing_fields}") if missing_fields.size > 0
      users = Models::User.where {email == context.params.json["email"]}.to_a
      return not_found(context, "Invalid credentials") if users.size == 0
      user = users[0]
      return not_found(context, "Invalid credentials") if user.password.

      puts user
      # puts "login in with"
      # puts context.params.json["email"]
      # puts context.params.json["password"]
      not_implemented(context)
    end

    def register(context)
      missing_fields = validate_body(context, [
        {"email", Const::Regex::EMAIL},
        {"password", nil}
      ])
      return invalid_query(context, "Missing field(s): #{missing_fields}") if missing_fields.size > 0
      begin
        profile = Models::Profile.create()
        user = Models::User.create({email: context.params.json["email"], password: context.params.json["password"], profile_id: profile.id})
      rescue ex
        return invalid_query(context, "email already existing") if ex.to_s.match(/user_email_index/)
        raise ex
      end
      login(context)
    end

  end

end
