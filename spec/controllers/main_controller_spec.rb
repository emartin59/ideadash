require 'rails_helper'

RSpec.describe MainController, type: :controller do

  describe "GET index" do
    it 'renders index' do
      get :index
      expect(response).to render_template :index
    end
    it 'is successful' do
      get :index
      expect(response).to be_success
    end
    it 'assigns new Subscriber' do
      get :index
      expect(assigns[:subscriber]).to be_kind_of Subscriber
      expect(assigns[:subscriber]).to be_new_record
    end
  end

  describe "POST subscribe" do
    context "with valid email" do
      it 'renders subscribe' do
        xhr :post, :subscribe, { subscriber: { email: 'test@example.com' } }
        expect(response).to render_template :subscribe
      end
      it 'creates subscriber' do
        expect {
          xhr :post, :subscribe, { subscriber: { email: 'test@example.com' } }
        }.to change(Subscriber, :count).by(1)
      end
    end
    context "with invalid email" do
      it 'renders subscribe' do
        xhr :post, :subscribe, { subscriber: { email: 'test@' } }
        expect(response).to render_template :subscribe
      end
      it 'creates subscriber' do
        expect {
          xhr :post, :subscribe, { subscriber: { email: 'test@' } }
        }.to_not change(Subscriber, :count)
      end
    end
  end

  describe "GET letsencrypt" do
    it 'renders validation string' do
      get :letsencrypt
      expect(response.body).to eq 'EDRa5RfvqS71twzPAfvzzAcnNSi4BhaalAld5Y5SVHQ.RxQRd4Fobz-EYXXu2uCEebPb8NjiQNF8r1w4uX0Jxwc'
    end
  end
end
