ActiveAdmin.register ::Comment do
  index do
    id_column
    column :body
    column :commentable
    column :created_at
    actions
  end


  show do
    attributes_table do
      row :id
      row :commentable
      row :title
      row :body
      row :subject
      row :user
      row :parent
      row :flags_count
    end

    if comment.flags.any?
      panel "Flags" do
        table_for comment.flags do
          column :user
          column('Kind'){|flag| Flag::KINDS[flag.kind.to_sym]}
          column :description
        end
      end
    end
  end
end
