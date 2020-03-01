require "./user"
require "./category"

module Pilbear::Models
  class UserCategory < Jennifer::Model::Base
    mapping(
      id: Primary32,
      user_id: Int32?,
      category_id: String?,
    )

    belongs_to :user, User
    belongs_to :category, Category
  end
end
