class AddOrderColumn < ActiveRecord::Migration[6.1]
  def up
    add_column(:folders, :order, :integer, null: false, default: 0, limit: 8)
    add_column(:projects, :order, :integer, null: false, default: 0, limit: 8)

    Folder.update_all('`order` = id')
    Project.update_all('`order` = id')
  end

  def down
    remove_column(:folders, :order)
    remove_column(:projects, :order)
  end
end
