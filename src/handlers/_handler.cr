require "kemal"
require "../services/validator"
require "../models/user"

module Pilbear::Handlers

  class PilbearHandler

    @@validator = Services::Validator.new

    def current_user?(context) : Models::User?
      return nil if context.get("user_id") == nil
    end

    def current_user!(context) : Models::User
      Models::User.find!(context.get("user_id").as(Int32))
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

    def not_found(context, error)
      context.response.status_code = 404
      {"error": "Not found. #{error}"}.to_json
    end

    def invalid_query(context, error)
      context.response.status_code = 400
      {"error": "Invalid query. #{error}"}.to_json
    end

    def not_implemented(context)
      context.response.status_code = 521
      {"error": "Not implemented"}.to_json
    end

  end

end
