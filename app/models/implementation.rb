class Implementation < ActiveRecord::Base
  attr_accessor :tos_accepted
  belongs_to :user
  belongs_to :idea

  validates :title, presence: true, uniqueness: { scope: :idea_id }, length: { maximum: 60 }
  validates :summary, presence: true, length: { maximum: 200 }
  validates :user, presence: true
  validates :tos_accepted, acceptance: { accept: '1' }

  validates :idea_id, uniqueness: { scope: :user_id }
end
