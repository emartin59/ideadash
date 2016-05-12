class Idea < ActiveRecord::Base
  belongs_to :user

  MAX_SUMMARY_LENGTH = 200

  validates :title, presence: true, uniqueness: true
  validates :summary, presence: true, length: { maximum: MAX_SUMMARY_LENGTH }
  validates :user, presence: true
end
