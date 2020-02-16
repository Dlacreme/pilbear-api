class Category < Jennifer::Model::Base
  mapping(
    id: {type: String, primary: true},
    label: String,
    is_disabled: Bool,
  )
end
