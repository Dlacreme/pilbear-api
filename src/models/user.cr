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

    belongs_to :profile, Profile

    def jwt_encode
      Services::JWT.encode(self.id.not_nil!.to_i64)
    end

    def print
      p : Profile = (self.profile != nil ? self.profile : Models::Profile.find!(self.profile_id)).as(Profile)
      return {
        "email"       => self.email,
        "role"        => self.user_role,
        "nickname"    => p.nickname,
        "first_name"  => p.first_name,
        "last_name"   => p.last_name,
        "picture_url" => p.picture_url,
        "birthdate"   => p.birthdate,
        "gender"      => p.gender,
      }
    end
  end
end
