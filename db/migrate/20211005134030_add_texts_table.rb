class AddTextsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :configurable_texts do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :value, null: false
      t.string :format, null: false, default: 'text'
      t.timestamps

      t.index :name, unique: true
      t.index :code, unique: true
      t.index :format
    end
  end
end
