require "./location"
require "../models/user"
require "../models/event"
require "../models/location"
require "../models/event_user"
require "../models/profile"
require "../models/category"

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
      gender: {type: String, null: true, default: nil, converter: Jennifer::Model::EnumConverter},
    )

    JSON.mapping(
      id: {type: Int32?, emit_null: true},
      email: {type: String?, emit_null: true},
      role: {type: String?, emit_null: true},
      profile_id: {type: Int32?, emit_null: true},
      nickname: {type: String?, emit_null: true},
      first_name: {type: String?, emit_null: true},
      last_name: {type: String?, emit_null: true},
      picture_url: {type: String?, emit_null: true},
      birthdate: {type: Time?, emit_null: true},
      gender: {type: String?, emit_null: true},
      favorites: {type: Array(Models::Category)?, default: [] of Array(Models::Category), emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(User)
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
          "profiles.gender as gender")
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

    def with_favorites
      # puts Models::UserCategory.all
      #   .join(Models::Category) { Models::Category._id == Models::UserCategory._category_id && Models::UserCategory._user_id == self.id }
      #   .select("categories.*")
      #   .to_a
      # self
      self.favorites = Models::Category.all
        .join(Models::UserCategory) { Models::UserCategory._category_id == Models::Category._id }
        .where { sql("user_categories.user_id = %s", [self.id]) }
        .to_a
      self
    end
  end
end
