require "jwt"
require "../const"

module Pilbear::Services
  class JWT
    def self.encode(user_id : Int64) : String
      expire_date = Time.utc + 30.days
      ::JWT.encode({
        "user_id" => user_id,
        "expire"  => expire_date.to_unix,
      }, ENV["PILBEAR_SECRET"], ::JWT::Algorithm::HS256)
    end

    def self.decode(token) : Int64 | Nil
      payload, header = ::JWT.decode(token, ENV[Const::Env::SECRET], ::JWT::Algorithm::HS256)
      return nil if payload["expire"].as_i64 < Time.utc.to_unix
      payload["user_id"].as_i64
    rescue
      nil
    end
  end
end
