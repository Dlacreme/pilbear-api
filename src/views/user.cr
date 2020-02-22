require "./location"
require "../models/user"
require "../models/event"
require "../models/location"
require "../models/event_user"
require "../models/profile"

module Pilbear::Views

  class User < Jennifer::View::Base

    mapping(
      id: {type: Int32, primary: true},
      email: String,
      role: {type: String, null: false, default: "user", converter: Jennifer::Model::EnumConverter},
      profile_id: {type: Int32, null: false},
      nickname: {type: String, null: true},
      first_name: {type: String, null: true},
      last_name: {type: String, null: true},
      picture_url: {type: String, null: true},
      birthdate: {type: Time, null: true},
      gender: {type: String, null: true, default: nil, converter: Jennifer::Model::EnumConverter}
    )

    JSON.mapping(
      id: Int32?,
      email: String?,
      role: String?,
      profile_id: Int32?,
      nickname: String?,
      first_name: String?,
      last_name: String?,
      picture_url: String?,
      birthdate: Time?,
      gender: String?,
    )

    def self.query() : Jennifer::QueryBuilder::ModelQuery(User)
      User.all
        .join(Models::Profile) { Models::Profile._id == User._profile_id }
        .select(
          "users.id as id," \
          "users.email as email," \
          "users.user_role as role," \
          "users.profile_id as profile_id," \
          "profiles.nickname as nickname," \
          "profiles.first_name as first_name," \
          "profiles.last_name as last_name," \
          "profiles.picture_url as picture_url," \
          "profiles.birthdate as birthdate," \
          "profiles.gender as gender"
        )
    end

    def self.find!(id) : User
      users = Views::User.query
        .where { sql("users.id = %s", [id]) }
        .to_a[0]
    end

    def self.find?(id) : User | Nil
      users = Views::User.query
        .where { sql("users.id = %s", [id]) }
        .to_a
      return nil if users.size == 0
      users[0]
    end

  end

end
