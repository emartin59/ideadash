class Idea < ActiveRecord::Base
  attr_accessor :tos_accepted

  belongs_to :user
  has_many :incoming_payments, as: :recipient, class_name: 'Payment'

  has_many :positive_votes, class_name: 'Vote',
           inverse_of: :positive_idea, foreign_key: 'positive_idea_id'

  has_many :negative_votes, class_name: 'Vote',
           inverse_of: :negative_idea, foreign_key: 'negative_idea_id'

  has_many :flags, as: :flaggable

  MAX_SUMMARY_LENGTH = 200

  SAFE_ORDERS = {
      newest: 'ideas.created_at DESC',
      oldest: 'ideas.created_at ASC',
      rating: '(positive_votes_count::float / (positive_votes_count + negative_votes_count + 1)) DESC'
  }

  validates :title, presence: true, uniqueness: true, length: { maximum: 60 }
  validates :summary, presence: true, length: { maximum: MAX_SUMMARY_LENGTH }
  validates :user, presence: true
  validates :tos_accepted, acceptance: { accept: '1' }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(created_at: :desc) }

  scope :current, -> { where('extract(month from ideas.created_at) = extract(month from current_date)') }
  scope :safe_order, -> (order_str){ unscope(:order).order(SAFE_ORDERS.fetch(order_str){ SAFE_ORDERS[:rating] }) }
  scope :visible, -> { where('ideas.flags_count < ? OR approved = ?', 5, true) }


  def rating
    positive_votes_count.to_f / ( positive_votes_count + negative_votes_count + 1 )
  end

  def formatted_rating
    sprintf('%.1f', rating * 10)
  end

  def in_first_phase?
    created_at > Time.now.beginning_of_month
  end
end
