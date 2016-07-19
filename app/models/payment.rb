require 'paypal_sdk'

class Payment < ActiveRecord::Base
  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  validates :amount, numericality: { greater_than_or_equal_to: 1 }

  delegate :url_helpers, to: 'Rails.application.routes'

  before_create :create_paypal_payment, if: :process_by_paypal?
  before_create :process_payment, unless: :process_by_paypal?

  scope :successful, -> { where("paypal_status = 'approved' OR paypal_id IS NULL") }

  def paypal_payment
    @payment ||= PaypalSdk::Payment.find(paypal_id)
  end

  def process_paypal_payment(opts)
    if (result = paypal_payment.execute(opts))
      Payment.transaction do
        recipient.lock!
        recipient.balance += amount
        recipient.save!
        self.paypal_status = paypal_payment.state
        self.transaction_fee = pp_transaction_fee
        self.paypal_payer_id = pp_payer_id
        save
        recipient.increment_backers_count!(sender) if recipient.respond_to? :increment_backers_count!
      end
    end
    result
  end

  def process_by_paypal?
    sender_type == 'User' && recipient_type == 'Idea' && sender.balance < amount
  end

  def paypal_payment?
    paypal_id.present? && paypal_status == 'approved'
  end

  private

  def process_payment
    Payment.transaction do
      sender.lock!
      recipient.lock!
      sender.balance -= amount
      sender.save!
      recipient.balance += amount
      recipient.increment_backers_count! sender if recipient.respond_to? :increment_backers_count!
      recipient.save!
    end
  end

  def create_paypal_payment
    @payment = PaypalSdk::Payment.new({
                               intent:        'sale',
                               payer:         { payment_method: 'paypal' },
                               redirect_urls: {
                                   return_url: url_helpers.callback_payments_url(host: ENV['APPLICATION_URL']),
                                   cancel_url: url_helpers.idea_url(recipient, host: ENV['APPLICATION_URL'], status: :canceled)
                               },
                               transactions:  [
                                                  {
                                                      item_list:   {
                                                          items: [
                                                                     {
                                                                         name:     "Funding of #{recipient.title}",
                                                                         sku:      "#{recipient_type.downcase}_#{recipient_id}",
                                                                         price:    paypal_amount,
                                                                         currency: 'USD',
                                                                         quantity: 1
                                                                     }
                                                                 ]
                                                      },
                                                      amount:      {
                                                          total:    paypal_amount,
                                                          currency: 'USD'
                                                      },
                                                      description: 'IdeaDash idea funding.'
                                                  }
                                              ]
                           }
    )
    if @payment.create
      self.paypal_id     = @payment.id
      self.paypal_status = @payment.state
    else
      errors.add(:base, @payment.error[:details].map { |issue| issue[:issue] })
      return false
    end
  end

  def paypal_amount
    sprintf('%.2f', amount)
  end

  def pp_transaction_fee
    tr = paypal_payment.transactions.first
    return 0 if tr.nil?
    related = tr.related_resources.first
    return 0 if related.nil?
    related.sale.transaction_fee.value.to_f
  end

  def pp_payer_id
    paypal_payment.payer.payer_info.payer_id
  end
end
