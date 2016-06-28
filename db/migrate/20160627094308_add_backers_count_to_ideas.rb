class AddBackersCountToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :backers_count, :integer, default: 0, index: true
  end
end
