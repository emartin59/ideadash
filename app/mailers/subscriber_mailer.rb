class SubscriberMailer < ApplicationMailer

  def subscription_notice(subscriber)
    mail to: subscriber.email
  end
end
