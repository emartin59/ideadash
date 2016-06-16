class User < ActiveRecord::Base
  has_merit

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  has_many :ideas
  has_many :votes
  has_many :flags
  has_many :implementations
  has_many :outgoing_payments, as: :sender, class_name: 'Payment'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

  def more_votes_allowed?
    @more_votes_allowed ||= (votes.recent.count < 100)
  end

  def can_flag?(flaggable)
    flags.where(flaggable: flaggable).empty?
  end
end
