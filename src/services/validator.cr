
module Pilbear::Services

  class Validator

    def validate(str : String, pattern : Regex) : Bool
      return true if pattern == nil
      str.match(pattern) != nil
    end

    def validate(any, noth) : Bool
      true
    end

  end

end
