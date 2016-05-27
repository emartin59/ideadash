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
  end

  describe "GET letsencrypt" do
    it 'renders validation string' do
      get :letsencrypt
      expect(response.body).to eq 'EDRa5RfvqS71twzPAfvzzAcnNSi4BhaalAld5Y5SVHQ.RxQRd4Fobz-EYXXu2uCEebPb8NjiQNF8r1w4uX0Jxwc'
    end
  end
end
