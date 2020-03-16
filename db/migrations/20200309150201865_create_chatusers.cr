class CreateChatusers < Jennifer::Migration::Base
  def up
    create_table :chat_users do |t|
      t.bool :message_pending, { :null => false, :default => true }

      t.reference :chat
      t.reference :user

      t.timestamps
    end
  end

  def down
    drop_foreign_key :chat_users, :chat if foreign_key_exists? :chat_users, :chat
    drop_foreign_key :chat_users, :user if foreign_key_exists? :chat_users, :user
    drop_table :chat_users if table_exists? :chat_users
  end
end
