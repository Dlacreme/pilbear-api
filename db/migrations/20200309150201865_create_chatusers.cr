class CreateChatusers < Jennifer::Migration::Base
  def up
    create_table :chatusers do |t|
      t.bool :message_pending, { :null => false, :default => true }

      t.reference :chat
      t.reference :user

      t.timestamps
    end
  end

  def down
    drop_foreign_key :chatusers, :chat if foreign_key_exists? :chatusers, :chat
    drop_foreign_key :chatusers, :user if foreign_key_exists? :chatusers, :user
    drop_table :chatusers if table_exists? :chatusers
  end
end
