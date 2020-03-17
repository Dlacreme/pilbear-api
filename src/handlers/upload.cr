require "file"
require "./_handler"
require "../services/s3"

module Pilbear::Handlers
  class UploadHandler < PilbearHandler
    def upload(context)
      url = Services::Upload.put(
        context.params.files["image"].tempfile,
        "#{context.params.url["type"]}_#{user_id}#{File.extname(context.params.files["image"].filename.as(String))}"
      )
      {"file_url": url}.to_json
    rescue ex
      {"error": "Upload failed"}.to_json
    end
  end
end
