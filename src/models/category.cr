
module Pilbear::Models
  class Category < Jennifer::Model::Base
    mapping(
      id: {type: String, primary: true},
      label: String,
      is_disabled: Bool,
    )
    JSON.mapping(
      id: String?,
      label: String?,
      is_disabled: Bool?,
    )
  end
end
