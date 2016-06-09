require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user){ create :user }
  let(:idea){ create :idea }

  before { sign_in user }
  describe "POST create" do
    context "internal payment" do
      context "with enough money" do
        let(:user){ create :user, balance: 12 }
        it 'creates payment' do
          expect{
            post :create, idea_id: idea.id, payment: { amount: 5 }
          }.to change(Payment, :count).by 1
        end
        it 'changes idea balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(idea.reload.balance).to eq 5
        end
        it 'changes user balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(user.reload.balance).to eq 7
        end
        it 'redirects to idea' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(response).to redirect_to idea
        end
      end
      context "with not enough money" do
        let(:user){ create :user }
        before { allow_any_instance_of(Payment).to receive(:paypal_payment?).and_return(false) }
        it 'does not create payment' do
          expect{
            post :create, idea_id: idea.id, payment: { amount: 5 }
          }.to_not change(Payment, :count)
        end
        it 'does not change idea balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(idea.reload.balance).to eq 0
        end
        it 'does not change user balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(user.reload.balance).to eq 0
        end
        it 'redirects to idea' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(response).to redirect_to idea
        end
      end
    end
    context "paypal payment" do
      it 'creates payment' do
        expect{
          post :create, idea_id: idea.id, payment: { amount: 5 }
        }.to change(Payment, :count).by 1
      end
      it 'redirects to payment url' do
        post :create, idea_id: idea.id, payment: { amount: 5 }
        payment = Payment.last
        expect(response).to redirect_to payment.paypal_payment.links.find{|v| v.method == "REDIRECT" }.href
      end
    end
  end

  describe "GET callback" do
    it 'redirects to root if no payment found' do
      get :callback
      expect(response).to redirect_to root_path
    end
    context "when payment is found" do
      subject{ create :payment, sender: user, recipient: idea, paypal_id: '12345678' }
      context "and it is successful" do
        before { allow_any_instance_of(Payment).to receive(:process_paypal_payment).and_return true }
        it 'redirects to idea' do
          get :callback, paymentId: subject.paypal_id
          expect(response).to redirect_to idea
        end
      end
      context "and it is not successful" do
        before { allow_any_instance_of(Payment).to receive(:process_paypal_payment).and_return false }
        it 'redirects to idea' do
          get :callback, paymentId: subject.paypal_id
          expect(response).to redirect_to idea
        end
      end
    end
  end
end
