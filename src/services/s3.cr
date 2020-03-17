require "awscr-s3"

module Pilbear::Services
  class Upload
    @@bucket_name = "pilbeardev"
    @@client = Awscr::S3::Client.new("eu-central-1", "AKIAXPNROKWRXDPW2OCV", "MNEMmweFRlsRuwMd7vIeTdiVhwFwTm7nvWJfK4D7")

    def self.put(file : File, name : String) : String
      @@client.put_object(@@bucket_name, name, file,
        {"x-amz-acl" => "public-read", "Content-Type" => self.get_content_type(File.extname(name))}
      )
      "https://pilbeardev.s3.eu-central-1.amazonaws.com/#{name}"
    end

    private def self.get_content_type(extension : String) : String
      case extension
      when ".jpg"
        return "image/jpeg"
      when ".jpeg"
        return "image/jpeg"
      when ".png"
        return "image/png"
      end
      return ""
    end
  end
end
