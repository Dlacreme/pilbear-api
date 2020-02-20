require "crypto/bcrypt/password"
require "./_handler"
require "../const"
require "../models/user"
require "../services/jwt"

#
module Pilbear::Handlers

  class UserHandler < PilbearHandler

    def get_me(context)
      current_user!(context).print.to_json
    end

    def get(context)
      u = Models::User.find(context.params.url["id"])
      return not_found(context, "User not found") if u == nil
      u.as(Models::User).print.to_json
    end

    def search(context)
      return ([] of String).to_json if !context.params.query["q"]
      q = "%#{context.params.query["q"]}%"
      Models::User.all.relation(:profile).where {
        sql("email ILIKE %s OR profiles.first_name ILIKE %s OR profiles.nickname ILIKE %s OR profiles.last_name ILIKE %s", [q, q, q, q])
      }.to_a.map { |u| u.print}.to_json
    end

    def login(context)
      missing_fields = validate_body(context, [
        {"email", Const::Regex::EMAIL},
        {"password", nil}
      ])
      return invalid_query(context, "Missing field(s): #{missing_fields}") if missing_fields.size > 0
      users = Models::User.where { sql("email like '#{context.params.json["email"].as(String)}'")}.to_a
      return not_found(context, "Invalid credentials") if users.size == 0
      user = users[0]
      return invalid_query(context, "Provider account") if user.password == nil
      password = Crypto::Bcrypt::Password.new(user.password.as(String))
      return not_found(context, "Invalid credentials") if password.verify(context.params.json["password"].as(String))
      data = user.print
      data["token"] = Services::JWT.encode(user.id.as(Int32))
      data.to_json
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
