class AddRootFolder < ActiveRecord::Migration[6.1]
  def up
    add_column(:folders, :root, :boolean)
    add_index(:folders, :root, unique: true)

    # Seed root folder
    root = Folder.where(root: true).first_or_create(name: 'Home')

    # Update Level-1 folders to now be nested under the root folder
    Folder.where(parent_folder_id: nil, root: nil).update_all(parent_folder_id: root.id)
  end

  def down
    root_ids = Folder.where(root: true).pluck(:id)
    Folder.where(parent_folder_id: root_ids).update_all(parent_folder_id: nil)
    Folder.where(id: root_ids).delete_all

    remove_column(:folders, :root)
  end
end
