require "../src/models/*"

def user
  p = Pilbear::Models::Profile.create({nickname: "Dlacreme", first_name: "Mathieu", last_name: "Delacroix"})
  Pilbear::Models::User.create({email: "mathieu@pilbear.com", password: "92dcd49d91c0ddf1c77443039371aad3", profile_id: p.id, user_role: "admin"})
  puts "User mathie@pilbear.com with password `toto42` created."
end

def language_country_city
  Pilbear::Models::Language.create({id: "EN", label: "English", label_en: "English"})
  Pilbear::Models::Language.create({id: "FR", label: "Francais", label_en: "French"})
  Pilbear::Models::Language.create({id: "VI", label: "Viet", label_en: "Viet"})

  Pilbear::Models::Country.create({id: "FR", label: "France", language_id: "FR"})
  Pilbear::Models::Country.create({id: "VN", label: "Viet Nam", language_id: "VI"})

  Pilbear::Models::City.create({label: "Besancon", country_id: "FR"})
  Pilbear::Models::City.create({label: "Paris", country_id: "FR"})
  Pilbear::Models::City.create({label: "Vesoul", country_id: "FR"})
  Pilbear::Models::City.create({label: "Ho Chi Minh City", country_id: "VN"})
  Pilbear::Models::City.create({label: "Hanoi", country_id: "VN"})
end

def category
  p = Pilbear::Models::Category.create({id: "other", label: "Other", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "archery", label: "Archery", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "badminton", label: "Badminton", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "baseball", label: "Baseball", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "bike", label: "Bike", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "billard", label: "Billard", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "bowling", label: "Bowling", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "martial_art", label: "Martial Art", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "car", label: "Car", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "chess", label: "Chess", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "cricket", label: "Cricket", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "dart", label: "Dart", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "climbing", label: "Climbing", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "football", label: "Football", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "golf", label: "Golf", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "gym", label: "Gym", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "handball", label: "Handball", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "ice_hockey", label: "Ice Hockey", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "moto", label: "Moto", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "parachute", label: "Parachute", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "running", label: "Running", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "scuba_diving", label: "Scuba Diving", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "skateboard", label: "Skateboard", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "ski", label: "Ski", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "surf", label: "Surf", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "swimming", label: "Swimming", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "table_tennis", label: "Table Tennis", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "tennis", label: "Tennis", is_disabled: false})
  p = Pilbear::Models::Category.create({id: "volleyball", label: "Volley Ball", is_disabled: false})
end

Sam.namespace "db" do
  task "seed" do
    user
    language_country_city
    category
  end
end
