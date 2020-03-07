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

    def update_from_hash(hash : Hash)
      self.nickname = hash["nickname"].as(String) if hash.has_key?("nickname") && hash["nickname"] != nil
      self.first_name = hash["first_name"].as(String) if hash.has_key?("first_name") && hash["first_name"] != nil
      self.last_name = hash["last_name"].as(String) if hash.has_key?("last_name") && hash["last_name"] != nil
      self.picture_url = hash["picture_url"].as(String) if hash.has_key?("picture_url") && hash["picture_url"] != nil
      self.birthdate = Converters::Datetime.from_string(hash["birthdate"].as(String)) if hash.has_key?("birthdate") && hash["birthdate"] != nil
      self.gender = hash["gender"].as(String) if hash.has_key?("gender") && hash["gender"] != nil
    end
  end
end
