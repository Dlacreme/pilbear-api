require "jennifer"
require "./user"

module Pilbear::Models

  class Profile < Jennifer::Model::Base

    mapping(
      id: {type: Int32, primary: true},
      nickname: {type: String, null: true},
      first_name: {type: String, null: true},
      last_name: {type: String, null: true},
      picture_url: {type: String, null: true},
      birthdate: {type: Time, null: true},
      gender: {type: String, null: true, default: nil, converter: Jennifer::Model::EnumConverter}
    )

    JSON.mapping(
      id: Int32?,
      nickname: String?,
      first_name: String?,
      last_name: String?,
      picture_url: String?,
      birthdate: Time?,
      gender: String?,
    )

    has_one :user, User

  end

end
