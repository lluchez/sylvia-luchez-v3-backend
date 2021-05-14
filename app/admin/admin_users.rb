ActiveAdmin.register AdminUser do
  actions :all, :except => [:destroy]
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  scope :all
  scope :active, :default => true do |admin_users|
    admin_users.active
  end
  scope :locked do |admin_users|
    admin_users.locked
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do |admin_user|
    attributes_table :title => 'Account Details' do
      row :email
      row :failed_attempts
      row :locked_at
      row :created_at
      row :updated_at
    end
    attributes_table :title => "Tracking" do
      row :current_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_at
      row :last_sign_in_ip
    end
    active_admin_comments
    panel "Change History", 'data-panel' => :collapsed, :class => 'change-history' do
      render "admin/shared/audit_table", :context => self
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
