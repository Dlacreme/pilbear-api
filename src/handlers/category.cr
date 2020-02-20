require "./_handler"
require "../models/category"

module Pilbear::Handlers

  class CategoryHandler < PilbearHandler

    def list(context)
      cat_query = Models::Category.all
      if context.params.query.has_key?("q")
        q = "%#{context.params.query["q"]}"
        cat_query = cat_query.where {sql("label ILIKE %s", [q])}
      end
      cat_query.to_a.to_json
    end

  end

end
