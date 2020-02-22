class CreateCategories < Jennifer::Migration::Base
  def up
    create_table :categories do |t|
      t.string :id, {:size => 255, :primary => true, :null => false}
      t.string :label, { :null => false }
      t.bool :is_disabled, { :null => false, :default => false }
    end
  end

  def down
    drop_table :categories if table_exists? :categories
  end
end
