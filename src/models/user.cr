require "jennifer"
require "./profile"

module Pilbear::Models

  class User < Jennifer::Model::Base
    with_timestamps
    mapping(
      id: {type: Int32, primary: true},
      email: String,
      password: {type: String, null: true},
      user_provider: {type: String, null: true},
      provider_id: {type: String, null: true},
      user_role: {type: String, null: false, default: "user", converter: Jennifer::Model::EnumConverter},
      profile_id: {type: Int32, null: false},
      created_at: {type: Time, null: true},
      updated_at: {type: Time, null: true}
    )

    has_one :profile, Profile

    def self.get!(id : Int32) : Hash
      u = User.find!(id)
      puts u

      return u.print
    end

    def print
      return {
        "email" => u.email
      }
    end

  end

end
