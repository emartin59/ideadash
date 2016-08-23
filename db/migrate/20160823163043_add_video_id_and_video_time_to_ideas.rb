class AddVideoIdAndVideoTimeToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :video_id, :string
    add_column :ideas, :video_time, :integer
  end
end
