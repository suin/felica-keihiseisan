ActiveAdmin.register Card do
  permit_params :user_id, :name
  menu priority: 20

  filter :holder
  filter :idm
  filter :name

  controller do
    actions :all, :except => [:new, :destroy, :show]
  end

  index do
    column :idm
    column :holder, :sortable => :user_id
    column :name
    column :system_code
    column :system
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :idm, :input_html => { disalbed: true }
      f.input :holder
      f.input :name
    end
    f.actions
  end
end
