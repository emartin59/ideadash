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

  show do
    h1 "# #{ idea.id } " + idea.title
    h3 idea.summary
    h3 link_to "by " + idea.user.name, send("#{ active_admin }_user_path", idea.user)
    div do
      simple_format idea.description
    end
    div "Created: " + idea.created_at.to_formatted_s
    div "Updated: " + idea.updated_at.to_formatted_s
    div "Rating: #{ idea.rating.round(2) } (+#{ idea.positive_votes_count } / -#{ idea.negative_votes_count })"
    div "Balance: #{ idea.balance.to_f }"
    div "Amount raised: #{ idea.amount_raised.to_f }"
    div "Approved: #{ idea.approved }"
    div "Backers count: #{ idea.backers_count }"

    if idea.flags.any?
      panel "Flags" do
        table_for idea.flags do
          column :user
          column('Kind'){|flag| Flag::KINDS[flag.kind.to_sym]}
          column :description
        end
      end
    end
  end

  controller do
    def scoped_collection
      super.includes :user
    end
  end
end
