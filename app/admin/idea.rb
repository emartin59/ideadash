ActiveAdmin.register Idea do

  permit_params :title, :description, :summary, :user_id

  index do
    selectable_column
    column :title
    column :created_at
    column :user
    actions
  end

  controller do
    def scoped_collection
      super.includes :user
    end
  end
end
