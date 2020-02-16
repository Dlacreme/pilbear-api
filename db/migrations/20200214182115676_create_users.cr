class CreateUsers < Jennifer::Migration::Base
  def up

    create_enum(:gender_enum, ["male", "female"])

    create_enum(:user_role_enum, ["admin", "user"])

    create_enum(:user_provider_enum, ["google", "facebook"])

    create_table(:profiles) do |t|
      t.string :nickname, {:size => 255, :null => true}
      t.string :first_name, {:size => 255, :null => true}
      t.string :last_name, {:size => 255, :null => true}
      t.field :gender, :gender_enum, {:null => true}
      t.timestamp :birthdate, {:null => true}
      t.string :picture_url, {:size => 500, :null => true}
    end

    create_table(:users) do |t|
      t.string :email, {:size => 255, :null => false}
      t.string :password, {:size => 255, :null => true}
      t.field :user_provider, :user_provider_enum, {:null => true}
      t.string :provider_id, {:size => 255, :null => true}
      t.field :user_role, :user_role_enum
      t.reference :profile
      t.timestamps
      t.index "user_email_index", :email, type: :unique
    end

  end

  def down
    drop_table :users
    drop_table :profiles
    drop_enum :gender_enum
    drop_enum :user_role_enum
    drop_enum :user_provider_enum
  end
end
