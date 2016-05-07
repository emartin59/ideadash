class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  after_create :send_email

  private
  def send_email
    SubscriberMailer.subscription_notice(self).deliver_now
  end
end
