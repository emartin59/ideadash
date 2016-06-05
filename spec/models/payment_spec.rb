require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject{ build :payment }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :recipient }
  it { is_expected.to belong_to :sender }
  it { is_expected.to validate_numericality_of(:amount) }

  describe "#paypal_payment?" do
    context "when user is a sender and recipient is idea and user balance is 0" do
      let(:user){ build(:user) }
      let(:idea){ build(:idea) }
      subject(:payment){ build :payment, sender: user, recipient: idea }
      subject{ payment.send :paypal_payment? }

      it{ is_expected.to be_truthy }
    end
    context "when user is a sender and recipient is idea and user balance is 10" do
      let(:user){ build(:user, balance: 10) }
      let(:idea){ build(:idea) }
      subject(:payment){ build :payment, sender: user, recipient: idea }
      subject{ payment.send :paypal_payment? }

      it{ is_expected.to be_falsey }
    end
    context "when idea is a sender" do
      let(:idea){ build(:idea) }
      subject(:payment){ build :payment, sender: idea, recipient: idea }
      subject{ payment.send :paypal_payment? }

      it{ is_expected.to be_falsey }
    end
    context "when user is a recipient" do
      let(:user){ build(:user) }
      let(:idea){ build(:idea) }
      subject(:payment){ build :payment, sender: idea, recipient: user }
      subject{ payment.send :paypal_payment? }

      it{ is_expected.to be_falsey }
    end
  end
end
