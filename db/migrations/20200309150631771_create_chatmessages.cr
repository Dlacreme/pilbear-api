class CreateChatmessages < Jennifer::Migration::Base
  def up
    create_table :chat_messages do |t|
      t.string :message, { :null => false }

      t.reference :chat
      t.reference :user

      t.timestamps
    end
  end

  def down
    drop_foreign_key :chat_messages, :chat if foreign_key_exists? :chat_messages, :chat
    drop_foreign_key :chat_messages, :user if foreign_key_exists? :chat_messages, :user
    drop_table :chat_messages if table_exists? :chat_messages
  end
end
