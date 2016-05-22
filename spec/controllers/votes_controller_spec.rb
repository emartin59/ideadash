require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user){ create :user }

  before{ sign_in user }

  describe "GET #start" do
    it "returns http success" do
      get :start
      expect(response).to have_http_status(:success)
    end
    it 'loads ideas' do
      get :start
      expect(assigns[:ideas]).to be_kind_of Array
    end
    it 'generates voting list' do
      expect_any_instance_of(VotingListBuilder).to receive(:generate)
      get :start
    end
  end

  # describe "POST #finish" do
  #   it "returns http success" do
  #     get :finish
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
