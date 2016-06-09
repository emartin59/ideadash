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
        it 'changes idea balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(idea.reload.balance).to eq 0
        end
        it 'changes user balance' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(user.reload.balance).to eq 0
        end
        it 'redirects to idea' do
          post :create, idea_id: idea.id, payment: { amount: 5 }
          expect(response).to redirect_to idea
        end

      end
    end
  end
end
