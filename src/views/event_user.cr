require "./location"
require "../models/user"
require "../models/event"
require "../models/location"
require "../models/event_user"

module Pilbear::Views
  class EventUser < Jennifer::View::Base
    mapping(
      id: Primary32,
      user_id: Int32,
      event_id: Int32,
      event_user_role: {type: String, converter: Jennifer::Model::EnumConverter},
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      user_id: {type: Int32?, emit_null: true},
      event_id: {type: Int32?, emit_null: true},
      event_user_role: {type: String, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true},
      user: {type: User?, emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(EventUser)
      q = EventUser.all
        .join(Model::User) { Models::User._id == EventUser._user_id }
        .join(Models::Profile) { Models::Profile._id == User.profile_id }
        .select(
          "users.id as user.id," \
          "users.email as user.email," \
          "users.user_role as user.role," \
          "users.profile_id as user.profile_id," \
          "profiles.id as user.profile.id," \
          "profiles.nickname as user.profile.nickname," \
          "profiles.first_name as user.profile.first_name," \
          "profiles.last_name as user.profile.last_name," \
          "profiles.picture_url as user.profile.picture_url," \
          "profiles.birthdate as user.profile.birthdate",
          "profiles.gender as user.profile.gender"
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
