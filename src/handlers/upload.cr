require "./_handler"
require "../services/s3"

module Pilbear::Handlers
  class UploadHandler < PilbearHandler
    def upload(context)
      Services::Upload.upload context.params.files["image"].tempfile
    rescue ex
      {"error": "Upload failed"}.to_json
    end
  end
end
