class AddBackerVotingResultToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :backer_voting_result, :string, default: 'extend', index: true
    add_reference :ideas, :implementation, index: true, foreign_key: true
  end
end
