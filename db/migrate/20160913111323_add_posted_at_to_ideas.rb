class AddPostedAtToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :posted_at, :datetime

    Idea.find_each do |idea|
      idea.update_column(:posted_at, idea.created_at)
    end

    change_column_null :ideas, :posted_at, false
  end

  def down
    remove_column :ideas, :posted_at
  end
end
