class Subscriber < ActiveRecord::Base
  validates :email, presence: { message: 'Please fill in the email field.' },
            uniqueness: { message: 'You are already subscribed!' }
  validates :email, email: { message: 'This email address is invalid.' }, if: 'email.present?'

  after_create :send_email

  private
  def send_email
    SubscriberMailer.subscription_notice(self).deliver_now
  end
end
