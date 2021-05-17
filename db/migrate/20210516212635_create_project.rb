class CreateProject < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :folder_id, null: false
      t.boolean :visible, null: false, default: true

      t.integer :year
      t.string :medium

      t.decimal :width
      t.decimal :height
      t.decimal :depth

      t.date :purchased_at
      t.string :purchased_by

      t.timestamps

      t.index :folder_id
      t.index :medium
      t.index :purchased_at
    end
  end
end
