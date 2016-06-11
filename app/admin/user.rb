ActiveAdmin.register User do

  permit_params :email, :name, :active

  form title: 'A custom title' do |f|
    inputs 'Details' do
      input :name
      input :email
      input :active
    end
    actions
  end

  index do
    selectable_column
    column :name
    column :email
    column :last_sign_in_at
    actions
  end
end
