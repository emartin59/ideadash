class Idea < ActiveRecord::Base
  attr_accessor :tos_accepted

  include AlgoliaSearch

  algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
    attribute :title, :summary, :description
  end

  acts_as_commentable

  belongs_to :user
  belongs_to :implementation
  has_many :incoming_payments, as: :recipient, class_name: 'Payment'

  has_many :positive_votes, class_name: 'Vote',
           inverse_of: :positive_idea, foreign_key: 'positive_idea_id'

  has_many :negative_votes, class_name: 'Vote',
           inverse_of: :negative_idea, foreign_key: 'negative_idea_id'

  has_many :flags, as: :flaggable
  has_many :implementations

  has_many :backer_votes

  MAX_SUMMARY_LENGTH = 200

  SAFE_ORDERS = {
      newest: 'ideas.created_at DESC',
      oldest: 'ideas.created_at ASC',
      backers: 'ideas.backers_count DESC',
      balance: 'ideas.balance DESC',
      rating: '(positive_votes_count::float / (positive_votes_count + negative_votes_count + 1)) DESC'
  }

  validates :title, presence: true, uniqueness: true, length: { maximum: 60 }
  validates :summary, presence: true, length: { maximum: MAX_SUMMARY_LENGTH }
  validates :user, presence: true
  validates :tos_accepted, acceptance: { accept: '1' }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(created_at: :desc) }

  scope :current, -> { where('extract(month from ideas.created_at) = extract(month from current_date)') }
  scope :previous, -> { where('extract(month from ideas.created_at) = extract(month from current_date) - 1') }
  scope :safe_order, -> (order_str){ unscope(:order).order(SAFE_ORDERS.fetch(order_str){ SAFE_ORDERS[:rating] }) }
  scope :visible, -> { where('ideas.flags_count < ? OR approved = ?', 5, true) }
  scope :pending_for_backer_voting, -> { where(backer_voting_result: 'extend').where('ideas.created_at < ?', Date.today.beginning_of_month) }


  def rating
    positive_votes_count.to_f / ( positive_votes_count + negative_votes_count + 1 )
  end

  def formatted_rating
    sprintf('%.1f', rating * 10)
  end

  def in_voting_phase?
    created_at > Date.today.beginning_of_month && created_at < Date.today.end_of_month + 1.day
  end

  def in_proposals_phase?
    return false if in_voting_phase?
    Date.today.day.between?(1, 21) && backer_voting_result == 'extend'
  end

  def in_backer_voting_phase?
    return false if in_voting_phase?
    backer_voting_result == 'extend'
  end

  def increment_backers_count!(sender)
    increment!(:backers_count) if incoming_payments.successful.where(sender: sender).count == 1
  end

  def calculate_backers_count
    update_column :backers_count, unique_backers_count
  end

  def unique_backers_count
    incoming_payments.successful.select(:sender_id).distinct.count
  end

  def top_backer_vote
    backer_votes_counts = backer_votes.select('MAX(backer_votes.kind) AS kind, max(backer_votes.implementation_id) as implementation_id, COUNT(backer_votes.id) AS count').group('backer_votes.kind')
    maximums = backer_votes_counts.max_by(2){|bv| bv.count}
    case
      when maximums.length == 0                   then return false
      when maximums.length == 1                   then return maximums[0]
      when maximums[0].count == maximums[1].count then return false
      else                                             return maximums[0]
    end
  end

  def set_voting_result
    backer_vote = top_backer_vote
    return unless backer_vote
    attrs = { backer_voting_result: backer_vote.kind }
    attrs.merge!(implementation_id: backer_vote.implementation_id) if backer_vote.implementation_id
    update(attrs)
  end

  def self.count_backer_voting_results
    pending_for_backer_voting.find_each do |idea|
      idea.set_voting_result
    end
  end
end
