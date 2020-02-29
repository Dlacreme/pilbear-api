require "kemal"
require "../services/validator"
require "../models/user"

module Pilbear::Handlers
  class PilbearHandler
    @@validator = Services::Validator.new

    macro user_id
      context.get("user_id").as(Int64).to_i
    end

    def current_user?(context) : Models::User?
      return nil if context.get("user_id") == nil
    end

    def current_user!(context) : Models::User
      Models::User.find!(user_id)
    end

    def validate_body(context : HTTP::Server::Context, fields : Array(Tuple(String, Regex | Nil))) : Array(String)
      hash = context.params.json
      errors = [] of String
      fields.each do |f|
        field_name = f[0]
        pattern = f[1]
        if hash.has_key?(field_name) == false
          errors.push("Field #{field_name} is missing.")
          next
        end
        next if pattern == nil
        if @@validator.validate(hash[field_name], pattern) == false
          errors.push("Field #{field_name} has an invalid format")
        end
      end
      errors
    end

    macro validate_body!(fields)
      missing_fields = validate_body(context, {{fields}})
      fail_query! "Missing field(s): #{missing_fields}" if missing_fields.size > 0
    end

    def ok(context)
      {"response": "ok"}.to_json
    end

    def not_found(context, error)
      context.response.status_code = 404
      {"error": "Not found. #{error}"}.to_json
    end

    macro not_found!(error)
      context.response.status_code = 404
      return {"error": "Not found. " + {{error}}}.to_json
    end

    def fail_query(context, error : Exception)
      context.response.status_code = 400
      msg = error.message || ""
      msg = "Relationship not found" if msg.includes?("out of bounds")
      {"error": msg}.to_json
    end

    def invalid_query(context, error : String)
      context.response.status_code = 400
      {"error": "Invalid query. #{error}"}.to_json
    end

    macro invalid_query!(error)
      context.response.status_code = 400
      return {"error": {{error}}.nil? ? "Invalid query." : {{error}} }.to_json
    end

    macro fail_query!(error)
      context.response.status_code = 400
      return {"error": "Invalid query." + {{error}}}.to_json
    end

    def not_implemented(context)
      context.response.status_code = 521
      {"error": "Not implemented"}.to_json
    end

    macro body
      context.params.json
    end
  end
end
