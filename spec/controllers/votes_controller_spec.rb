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

  describe "POST #finish" do
    let(:negative_idea){ create :idea }
    let(:positive_idea){ create :idea }
    it "returns success" do
      post :finish, votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}]
      expect(response).to have_http_status(:success)
    end
    it "renders finish template" do
      post :finish, votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}]
      expect(response).to render_template :finish
    end
    it "creates vote instance" do
      expect{
        post :finish, votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}]
      }.to change(Vote, :count).by(1)
    end
    it 'adds a point to user' do
      expect{
        post :finish, votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}]
      }.to change(user, :points).by(1)
    end
    context "invalid request" do
      it "skips invalid points" do
        expect{
          post :finish, votes: [{
                                    positive_idea_id: negative_idea.id
                                },
                                {
                                    negative_idea_id: negative_idea.id,
                                    positive_idea_id: positive_idea.id
                                }]
        }.to change(Vote, :count).by 1
        expect(response).to be_success
      end
    end
  end
end
