
module Pilbear::Converters

  class TimeConverter
    # See https://crystal-lang.org/api/master/Time.html#to_rfc2822%28io%3AIO%29-instance-method
    def self.from_db(pull, nillable)
      print pull
      Date.utc
    end

    def self.to_db(value : Time?)
      return value
      # Time.parse("2015-10-12 10:30:00 +00:00", "%Y-%m-%d %H:%M:%S %z", Time::Location::UTC)
    end

    def self.from_hash(hash : Hash, column)
      value = hash[column]
      print value
      return value
      # Time.
    end

  end

end