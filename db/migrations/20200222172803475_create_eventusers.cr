class CreateEventusers < Jennifer::Migration::Base
  def up

    create_enum(:event_user_role_enum, ["admin", "member"])

    create_table :event_users do |t|
      t.integer :user_id, { :null => false }
      t.integer :event_id, { :null => false }
      t.field :event_user_role, :event_user_role_enum, { :null => false }

      t.timestamps
    end
  end

  def down
    drop_table :event_users if table_exists? :event_users
    drop_enum :event_user_role_enum
  end
end
