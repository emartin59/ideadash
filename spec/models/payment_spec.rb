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

  describe "paypal payment processing" do
    let(:user){ create :user }
    let(:idea){ create :idea }
    subject{ build :payment, recipient: idea, sender: user }

    it "creates paypal payment with success" do
      expect_any_instance_of(PaypalSdk::Payment).to receive(:create).and_return true
      subject.save
    end

    it "creates paypal payment with error" do
      expect_any_instance_of(PaypalSdk::Payment).to receive(:create).and_return false
      expect_any_instance_of(PaypalSdk::Payment).to receive(:error).and_return({ details: [{issue: 'Wrong id'}] })
      subject.save
      expect(subject.errors[:base]).to eq [['Wrong id']]
    end

    describe "real payment creation" do
      it 'sets paypal id' do
        expect{
          subject.save
        }.to change(subject, :paypal_id)
        expect(subject.paypal_status).to eq 'created'
      end
    end
  end

  describe "#paypal_payment" do
    let(:user){ create :user }
    let(:idea){ create :idea }
    let(:payment){ create :payment, recipient: idea, sender: user }
    subject{ payment.paypal_payment }

    it 'returns paypal payment' do
      is_expected.to be_kind_of PaypalSdk::Payment
      expect(subject.id).to eq payment.paypal_id
    end
  end

  describe "internal payment processing" do
    let(:user){ create :user }
    let(:idea){ create :idea, balance: 10 }
    subject{ build :payment, recipient: user, sender: idea }

    context "with valid starting balances" do
      it 'updates both recipient balance' do
        expect{
          subject.save
        }.to change(user, :balance).by 5
      end
      it 'updates both sender balance' do
        expect{
          subject.save
        }.to change(idea, :balance).by -5
      end
      it 'keeps overall balance the same' do
        beginning_balance = user.balance + idea.balance
        subject.save
        ending_balance = user.balance + idea.balance
        expect(beginning_balance).to eq ending_balance
      end
    end
    context "with invalid starting balance" do
      let(:idea){ create :idea, balance: 3 }
      it 'updates recipient balance' do
        subject.save
        expect(user.reload.balance).to eq 0
      end
      it 'updates sender balance' do
        subject.save
        expect(idea.reload.balance).to eq 3
      end
      it 'keeps overall balance the same' do
        beginning_balance = user.balance + idea.balance
        subject.save
        ending_balance = user.reload.balance + idea.reload.balance
        expect(beginning_balance).to eq ending_balance
      end
    end
  end
end
