require "jennifer"
require "jennifer/adapter/postgres"

Jennifer::Config.read("config/database.yml", ENV["APP_ENV"]? || "development")
Jennifer::Config.from_uri(ENV["DATABASE_URI"]) if ENV.has_key?("DATABASE_URI")
# Jennifer::Config.from_uri("postgres://dounpppiruqezn:814f0a49cd4bbb294d1cc8dd89fca8e56ad5be5dbd4b497f0eb516ba1f8bbb95@ec2-184-72-235-80.compute-1.amazonaws.com:5432/d6c3325mivu0ga")

Jennifer::Config.configure do |conf|
  conf.logger.level = Logger::DEBUG
end
