class Idea < ActiveRecord::Base
  belongs_to :user

  has_many :positive_votes, class_name: 'Vote',
           inverse_of: :positive_idea, foreign_key: 'positive_idea_id'

  has_many :negative_votes, class_name: 'Vote',
           inverse_of: :negative_idea, foreign_key: 'negative_idea_id'

  attr_accessor :tos_accepted

  validates :tos_accepted, presence: { message: 'You must accept Terms of Service before you can proceed' }, on: :create

  MAX_SUMMARY_LENGTH = 200

  SAFE_ORDERS = {
      newest: 'ideas.created_at DESC',
      oldest: 'ideas.created_at ASC',
      rating: '(positive_votes_count::float / (positive_votes_count + negative_votes_count + 1)) DESC'
  }

  validates :title, presence: true, uniqueness: true
  validates :summary, presence: true, length: { maximum: MAX_SUMMARY_LENGTH }
  validates :user, presence: true

  scope :current, -> { where('extract(month from ideas.created_at) = extract(month from current_date)') }
  scope :safe_order, -> (order_str){ unscope(:order).order(SAFE_ORDERS.fetch(order_str)) }

  default_scope { order(created_at: :desc) }
end
