ActiveAdmin.register ConfigurableText do
  actions :all, :except => [:new, :create, :destroy]
  menu :label => "Texts"
  permit_params :value

  filter :name
  filter :code
  filter :created_at

  index do
    # selectable_column
    id_column
    column :name
    column :code
    column :formatted_format
    column :created_at
    actions
  end

  show do
    attributes_table :title => 'Text Details' do
      row :name
      row :formatted_format
      row :text do |ct|
        ct.value.html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
    panel "Change History", 'data-panel' => :collapsed, :class => 'change-history' do
      render "admin/shared/audit_table", :context => self
    end
  end

  form do |f|
    f.inputs do
      f.input :name, :input_html => { :disabled => true }
      f.input :value, :as => :quill_editor
    end
    f.actions
  end
end
