require "../src/models/profile"
require "../src/models/user"

def user
  p = Pilbear::Models::Profile.create({nickname: "Dlacreme", first_name: "Mathieu", last_name: "Delacroix"})
  Pilbear::Models::User.create({email: "mathieu@pilbear.com", password: "92dcd49d91c0ddf1c77443039371aad3", profile_id: p.id, user_role: "admin"})
  puts "User mathie@pilbear.com with password `toto42` created."
end

Sam.namespace "db" do
  task "seed" do
    user
  end
end
