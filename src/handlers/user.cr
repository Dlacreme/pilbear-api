require "crypto/bcrypt/password"
require "./_handler"
require "../const"
require "../models/user"
require "../services/jwt"
require "../views/user"

module Pilbear::Handlers
  class UserHandler < PilbearHandler
    def get_me(context)
      Views::User.find!(context.get("user_id").as(Int32)).to_json
    end

    def get(context)
      u = Views::User.find?(context.params.url["id"])
      not_found!("User not found") if u.nil?
      u.to_json
    end

    def search(context)
      return ([] of String).to_json if !context.params.query["q"]
      q = "%#{context.params.query["q"]}%"
      Views::User.query.where {
        sql("users.email ILIKE %s OR profiles.first_name ILIKE %s OR profiles.nickname ILIKE %s OR profiles.last_name ILIKE %s", [q, q, q, q])
      }.to_a.to_json
    end

    def login(context)
      validate_body!([
        {"email", Const::Regex::EMAIL},
        {"password", nil},
      ])
      users = Models::User.where { sql("email like '#{context.params.json["email"].not_nil!}'") }.to_a
      not_found!("Invalid credentials") if users.empty?
      user = users.first
      fail_query!("Provider account") if user.password.nil?
      password = Crypto::Bcrypt::Password.new(user.password.not_nil!)
      not_found!("Invalid credentials") if password.verify(context.params.json["password"].as(String))
      data = user.print
      data["token"] = Services::JWT.encode(user.id.not_nil!)
      data.to_json
    end

    def register(context)
      validate_body!([
        {"email", Const::Regex::EMAIL},
        {"password", nil},
      ])
      begin
        profile = Models::Profile.create
        user = Models::User.create(email: context.params.json["email"],
          password: context.params.json["password"],
          profile_id: profile.id)
      rescue ex
        fail_query! "email already existing" if ex.to_s.includes?("user_email_index")
        raise ex
      end
      login(context)
    end
  end
end
