class BackerVote < ActiveRecord::Base
  KINDS = %w(extend refund vote)

  belongs_to :user
  belongs_to :idea
  belongs_to :implementation

  validates :user, presence: true
  validates :idea, presence: true, uniqueness: { scope: :user_id }
  validates :implementation, presence: true, if: :is_vote?

  validate :user_backed_idea?

  def user_backed_idea?
    if Payment.successful.where(sender: user, recipient: idea).empty?
      errors.add(:base, 'You have not backed this idea.')
      return false
    end
    return true
  end

  def is_vote?
    kind == 'vote'
  end
end
