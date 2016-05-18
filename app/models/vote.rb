class Vote < ActiveRecord::Base
  belongs_to :positive_idea, class_name: 'Idea', foreign_key: :positive_idea_id,
             counter_cache: :positive_votes_count, inverse_of: :positive_votes
  belongs_to :negative_idea, class_name: 'Idea', foreign_key: :negative_idea_id,
             counter_cache: :negative_votes_count, inverse_of: :negative_votes
  belongs_to :user

  validates :positive_idea, presence: true
  validates :negative_idea, presence: true
  validates :user, presence: true
end
