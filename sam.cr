require "./config/*"
require "./db/migrations/*"
require "sam"
load_dependencies "jennifer"
require "./db/seed"

# task "test" do
#   puts "ping"
# end

Sam.help
