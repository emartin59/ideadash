class CreateBackerVotes < ActiveRecord::Migration
  def change
    create_table :backer_votes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :idea, index: true, foreign_key: true
      t.belongs_to :implementation, index: true, foreign_key: true
      t.string :kind, default: 'extend', index: true

      t.timestamps null: false
    end

    add_index :backer_votes, [:user_id, :idea_id], unique: true
  end
end
