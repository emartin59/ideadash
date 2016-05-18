class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :positive_idea, index: true, null: false
      t.belongs_to :negative_idea, index: true, null: false
      t.belongs_to :user, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_column :ideas, :positive_votes_count, :integer, default: 0
    add_column :ideas, :negative_votes_count, :integer, default: 0
  end
end
