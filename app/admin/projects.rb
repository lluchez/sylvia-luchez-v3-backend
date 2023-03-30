ActiveAdmin.register Project do
  actions :all, :except => [:destroy]
  permit_params :name, :folder_id, :visible, :year, :medium, :photo,
                :width, :height, :depth, :purchased_at, :purchased_by,
                :order, :price

  controller do
    def scoped_collection
      if ['index'].include?(params[:action])
        end_of_association_chain.includes(:folder, :photo_attachment => :blob)
      else
        super
      end
    end
  end

  index do
    # selectable_column
    id_column
    column :name
    column :folder
    column :image do |p|
      image_tag(p.sized_photo(:thumbnail), :class => 'project-thumbnail') if p.photo.persisted?
    end
    column :year
    column :medium
    column :price
    column :visible
    column :created_at do |p|
      p.created_at.to_date
    end
    actions
  end

  scope :all
  scope :visible, :default => true, &:visible
  scope :archived, &:archived
  scope :not_priced, &:not_priced

  filter :name
  filter :folder, :as => :select, :collection => proc { ActiveAdminHelper.folder_collection }
  filter :year
  filter :medium, :as => :select, :collection => proc { ActiveAdminHelper.unique_field_collection(Project, :medium) }
  filter :price
  filter :visible
  filter :created_at

  action_item :new_project, :only => :show do
    link_to('New Project', new_admin_project_path)
  end

  show do
    attributes_table :title => 'Project Details' do
      row :name
      row :folder
      row :photo do |project|
        render :partial => 'admin/photo', :locals => { :resource => project }
      end
      row :year
      row :medium
      row :price
      row :visible
      row :order
      row :created_at
      row :updated_at
    end

    attributes_table :title => 'Dimension' do
      row :width
      row :height
      row :depth
    end

    attributes_table :title => 'Ownership Details' do
      row :purchased_by
      row :purchased_at
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
      f.input :folder_id, :as => :select, :collection => ActiveAdminHelper.folder_collection
      f.input :photo, :as => :file
      f.input :year
      f.input :medium
      f.input :price
      f.input :visible
      f.input :order
    end
    f.inputs do
      f.input :width
      f.input :height
      f.input :depth
    end
    f.inputs do
      f.input :purchased_at
      f.input :purchased_by
    end
    f.actions
  end
end
