class CreateUserCategories < Jennifer::Migration::Base
  def up
    create_table :user_categories do |t|
      t.integer :user_id, {:null => false}
      t.string :category_id, {:null => false}
    end
  end

  def down
    drop_table :user_categories if table_exists? :user_categories
  end
end
