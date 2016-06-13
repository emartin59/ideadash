require 'rails_helper'

RSpec.describe FlagsController, type: :controller do
  let(:user){ create :user }
  let(:idea){ create :idea }
  before { sign_in user }
  describe "POST #create" do
    it 'returns success' do
      post :create, { flag: attributes_for(:flag), idea_id: idea.id }
      expect(response).to redirect_to idea_path(idea)
    end
    it 'creates flag' do
      expect{
        post :create, { flag: attributes_for(:flag), idea_id: idea.id }
      }.to change(Flag, :count).by 1
    end
    it 'does not create duplicated flags' do
      post :create, { flag: attributes_for(:flag), idea_id: idea.id }
      expect{
        post :create, { flag: attributes_for(:flag), idea_id: idea.id }
      }.to_not change(Flag, :count)
    end
  end
end
