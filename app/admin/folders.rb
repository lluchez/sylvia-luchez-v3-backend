ActiveAdmin.register Folder do
  actions :all, :except => [:destroy]
  permit_params :name, :photo, :from_year, :to_year, :parent_folder_id, :visible, :order

  controller do
    def scoped_collection
      if ['index'].include?(params[:action])
        end_of_association_chain.includes(:parent_folder, :photo_attachment => :blob)
      else
        super
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :parent_folder
    column :image do |p|
      image_tag(p.sized_photo(:thumbnail), :class => 'folder-thumbnail') if p.photo.persisted?
    end
    column :visible
    column :root
    column :created_at
    actions
  end

  scope :all
  scope :visible, :default => true, &:visible
  scope :root, &:root
  scope :archived, &:archived

  filter :name
  filter :parent_folder, :as => :select, :collection => proc { ActiveAdminHelper.folder_collection }
  filter :created_at

  action_item :new_folder, :only => :show do
    link_to('New Folder', new_admin_folder_path)
  end

  show do |f|
    attributes_table do
      row :name
      unless f.root?
        row :photo do |folder|
          render :partial => 'admin/photo', :locals => { :resource => folder }
        end
        row :from_year
        row :to_year
        row :parent_folder
      end
      row 'Sub folders' do |folder|
        folder.sub_folders.count
      end
      row 'Projects' do |folder|
        folder.projects.count
      end
      row :visible
      row :order
      row :created_at
      row :updated_at
    end
    active_admin_comments
    panel "Change History", 'data-panel' => :collapsed, :class => 'change-history' do
      render "admin/shared/audit_table", :context => self
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name, :required => true
      unless f.object.root?
        f.input :photo, :as => :file
        f.input :from_year
        f.input :to_year
        f.input :parent_folder_id, :as => :select, :collection => ActiveAdminHelper.folder_collection
        f.input :order
        f.input :visible
      end
    end
    f.actions
  end
end
