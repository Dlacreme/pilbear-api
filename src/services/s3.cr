require "awscr-s3"

module Pilbear::Services
  class Upload
    @@bucket_name = "pilbeardev"
    @@client = Awscr::S3::Client.new("eu-central-1", "AKIAXPNROKWRXDPW2OCV", "MNEMmweFRlsRuwMd7vIeTdiVhwFwTm7nvWJfK4D7")

    def self.put(file : File, name : String) : String
      @@client.put_object(@@bucket_name, name, file)
      "https://pilbeardev.s3.eu-central-1.amazonaws.com/#{name}"
    end
  end
end
