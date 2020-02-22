
module Pilbear::Converters

  class Datetime

    def self.from_string(data : String) : Time
      Time.parse(data, "%Y-%m-%dT%H:%M:%SZ", Time::Location::UTC)
    end

    # See https://crystal-lang.org/api/master/Time.html#to_rfc2822%28io%3AIO%29-instance-method
    def self.to_String(data : Time) : String
      data.to_rfc2822
    end
  end

end