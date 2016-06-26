ActiveAdmin.register ::Comment do
  index do
    id_column
    column :body
    column :commentable
    column :created_at
    actions
  end
end
