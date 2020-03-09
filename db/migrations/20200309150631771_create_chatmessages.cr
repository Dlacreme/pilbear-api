class CreateChatmessages < Jennifer::Migration::Base
  def up
    create_table :chatmessages do |t|
      t.string :message, { :null => false }

      t.reference :chat
      t.reference :user

      t.timestamps
    end
  end

  def down
    drop_foreign_key :chatmessages, :chat if foreign_key_exists? :chatmessages, :chat
    drop_foreign_key :chatmessages, :user if foreign_key_exists? :chatmessages, :user
    drop_table :chatmessages if table_exists? :chatmessages
  end
end
