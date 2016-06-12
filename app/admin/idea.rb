ActiveAdmin.register Idea do

  permit_params :title, :description, :summary, :user_id, :approved

  index do
    selectable_column
    column :title
    column :created_at
    column :user
    column :approved
    actions
  end

  controller do
    def scoped_collection
      super.includes :user
    end
  end
end
