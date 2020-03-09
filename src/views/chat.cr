module Pilbear::Views
  class Chat < Jennifer::View::Base
    mapping(
      id: Primary32,
      event_id: Int32,
      name: String,
      valid_time: Time?,
      deleted: Bool,
      created_at: Time?,
      updated_at: Time?,
    )

    JSON.mapping(
      id: {type: Int32, emit_null: true},
      event_id: {type: Int32, emit_null: true},
      name: {type: String, emit_null: true},
      valid_time: {type: Time?, emit_null: true},
      deleted: {type: Bool, emit_null: true},
      created_at: {type: Time?, emit_null: true},
      updated_at: {type: Time?, emit_null: true},
    )

    def self.query : Jennifer::QueryBuilder::ModelQuery(Chat)
      Chat.all
        .select(
          "id," \
          "event_id," \
          "name," \
          "valid_time," \
          "deleted," \
          "created_at," \
          "updated_at"
        )
    end
  end
end
