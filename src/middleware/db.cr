###
### Insert a DB Instance to our query
###

module Pilbear::Middleware

  class DBMiddleware < Kemal::Handler

    def call(context)
      puts "DB Middleware"
      call_next context
    end

  end

end
