class Idea < ActiveRecord::Base
  belongs_to :user

  MAX_SUMMARY_LENGTH = 200

  SAFE_ORDERS = {
      newest: 'ideas.created_at DESC',
      oldest: 'ideas.created_at ASC'
  }

  validates :title, presence: true, uniqueness: true
  validates :summary, presence: true, length: { maximum: MAX_SUMMARY_LENGTH }
  validates :user, presence: true

  scope :current, -> { where('extract(month from ideas.created_at) = extract(month from current_date)') }
  scope :safe_order, -> (order_str){ order(SAFE_ORDERS[order_str]) }

end
