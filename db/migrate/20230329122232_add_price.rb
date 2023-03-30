class AddPrice < ActiveRecord::Migration[7.0]
  def change
    add_column(:projects, :price, :decimal, :precision => 10, :scale => 2)
  end
end
