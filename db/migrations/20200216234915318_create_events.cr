class CreateEvents < Jennifer::Migration::Base
  def up

    create_enum(:confidentiality_enum, ["public", "private"])

    create_table :events do |t|
      t.string :label, { :size => 255, :null => false }
      t.string :description, { :null => true }
      t.field :confidentiality, :confidentiality_enum
      t.integer :capacity, { :null => false }
      t.integer :created_by_id, { :null => false }
      t.timestamp :start_date, { :null => false }
      t.timestamp :end_date, { :null => false }
      t.bool :is_disabled, { :null => false }
      t.string :category_id, { :null => false, :size => 255 }
      t.timestamps
    end
  end

  def down
    drop_table :events if table_exists? :events
    drop_enum :confidentiality_enum
  end
end
