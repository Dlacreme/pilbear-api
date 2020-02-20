class CreateLocations < Jennifer::Migration::Base
  def up

    create_table :languages do |t|
      t.string :id, { :size => 3, :null => false, :primary => true }
      t.string :label, { :size => 55, :null => false }
      t.string :label_en, { :size => 55, :null => false }
    end

    create_table :countries do |t|
      t.string :id, { :size => 3, :null => false, :primary => true }
      t.string :language_id, { :size => 3, :null => false }
      t.string :label, { :size => 255, :null => false }
    end

    create_table :cities do |t|
      t.string :label, { :size => 255, :null => false }
      t.string :country_id, { :size => 3, :null => false }
    end

    create_table :locations do |t|
      t.string :label, { :null => false }
      t.string :description, { :null => false }
      t.double :lat, { :null => false }
      t.double :lng, { :null => false }
      t.integer :city_id, { :null => false }
      t.integer :created_by_id, { :null => false }
      t.string :google_id, { :null => false }

      t.timestamps
    end
  end

  def down
    drop_table :city if table_exists? :city
    drop_table :languages if table_exists? :languages
    drop_table :cities if table_exists? :cities
    drop_table :countries if table_exists? :countries
    drop_table :locations if table_exists? :locations
  end
end
