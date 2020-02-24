
module Pilbear::Const

  module Message

  end

  module Regex
    EMAIL = /^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/
    PASSWORD = /(?=.*[a-z])/
  end

  module Env
    SECRET = "PILBEAR_SECRET"
  end

end
