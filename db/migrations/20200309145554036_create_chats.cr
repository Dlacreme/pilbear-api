class CreateChats < Jennifer::Migration::Base
  def up
    create_table :chats do |t|
      t.string :name, { :null => false }
      t.timestamp :valid_time
      t.bool :deleted, { :null => false, :default => false }

      t.reference :event

      t.timestamps
    end
  end

  def down
    drop_foreign_key :chats, :event if foreign_key_exists? :chats, :event
    drop_table :chats if table_exists? :chats
  end
end
