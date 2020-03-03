require "awscr-s3"

module Pilbear::Services
  class Upload
    @@client = Awscr::S3::Client.new("us-east1", "key", "secret")

    def self.upload(file : File)
      puts "UPLOAD "
      pp file
    end
  end
end
