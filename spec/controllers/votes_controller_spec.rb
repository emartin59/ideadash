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

    let(:signed_str) do
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
      str = positive_idea.id * negative_idea.id
      crypt.encrypt_and_sign(str.to_s)
    end

    let(:valid_attributes){ { votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}], signed_str: signed_str } }

    it "returns success" do
      post :finish, valid_attributes
      expect(response).to have_http_status(:success)
    end
    it "renders finish template" do
      post :finish, valid_attributes
      expect(response).to render_template :finish
    end
    it "creates vote instance" do
      expect{
        post :finish, valid_attributes
      }.to change(Vote, :count).by(1)
    end
    it 'adds a point to user' do
      expect{
        post :finish, valid_attributes
      }.to change(user, :points).by(1)
    end
    context "invalid request" do
      describe "with non-existent idea" do
        let(:signed_str) do
          crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
          str = [negative_idea.id, 9999].zip([positive_idea.id, negative_idea.id]).map{|x, y| x * y}.join
          crypt.encrypt_and_sign(str.to_s)
        end
        it "skips invalid points" do
          expect{
            post :finish, { votes: [{
                                        negative_idea_id: negative_idea.id,
                                        positive_idea_id: positive_idea.id
                                    }, {
                                        negative_idea_id: 9999,
                                        positive_idea_id: negative_idea.id
                                    }], signed_str: signed_str }
          }.to change(Vote, :count).by 1
          expect(response).to be_success
        end
      end
      describe "with fake signature" do
        let(:signed_str) { 'qwertyuiop' }
        it "does not create points" do
          expect{
            post :finish, { votes: [{
                                        negative_idea_id: negative_idea.id,
                                        positive_idea_id: positive_idea.id
                                    }, {
                                        negative_idea_id: 9999,
                                        positive_idea_id: negative_idea.id
                                    }], signed_str: signed_str }
          }.to_not change(Vote, :count)
          expect(response).to redirect_to start_votes_path
        end
      end
      describe "with invalid signature" do
        let(:signed_str) do
          crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
          str = positive_idea.id * negative_idea.id + 1
          crypt.encrypt_and_sign(str.to_s)
        end

        let(:attributes){ { votes: [{negative_idea_id: negative_idea.id, positive_idea_id: positive_idea.id}], signed_str: signed_str } }
        it "does not create points" do
          expect{
            post :finish, attributes
          }.to_not change(Vote, :count)
          expect(response).to redirect_to start_votes_path
        end
      end
    end
  end
end
