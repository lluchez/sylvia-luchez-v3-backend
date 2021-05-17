class CreateFolder < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|
      t.string :name, null: false
      t.boolean :visible, null: false, default: true
      t.integer :parent_folder_id
      t.integer :from_year
      t.integer :to_year
      t.timestamps

      t.index :parent_folder_id
    end
  end
end
