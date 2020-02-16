require "jwt"
require "../const"

module Pilbear::Services

  class JWT

    def encode(user_id : Int32) : String
      expire_date = Time.utc() + 30.days
      puts "EXPIRE DATE > "
      puts expire_date
      JWT.encode({
        "user_id" => user_id,
        "expire" => expire_date,
      }, ENV["PILBEAR_SECRET"], JWT::Algorithm::HS256)
    end

    def decode() : Int32 | Nil
      payload, header = JWT.decode(token, ENV[Const::Env::SECRET], JWT::Algorithm::HS256)
      puts payload
      puts header
      return nil if payload["expire"] < Time.utc()
      payload["user_id"]
    end

  end

end
