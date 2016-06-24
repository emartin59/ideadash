require 'rails_helper'

RSpec.describe ImplementationsController, type: :controller do
  let(:idea){ create :idea }
  let(:user){ create :user }

  describe "GET #index" do
    it 'renders index' do
      get :index, idea_id: idea.id
      expect(response).to render_template :index
    end
    it 'returns success' do
      get :index, idea_id: idea.id
      expect(response).to be_success
    end
  end
  describe "GET #show" do
    let(:implementation){ create :implementation, idea: idea }
    it 'renders show' do
      get :show, idea_id: idea.id, id: implementation.id
      expect(response).to render_template :show
    end
    it 'returns success' do
      get :show, idea_id: idea.id, id: implementation.id
      expect(response).to be_success
    end
  end
  context "for logged in user" do
    before do
      sign_in user
      idea.update(created_at: Date.today.beginning_of_month - 1.month)
    end
    describe "GET #new" do
      it 'renders new' do
        get :new, idea_id: idea.id
        expect(response).to render_template :new
      end
      it 'returns success' do
        get :new, idea_id: idea.id
        expect(response).to be_success
      end
    end
    describe "POST #create" do
      it 'creates implementation' do
        expect{
          post :create, idea_id: idea.id, implementation: attributes_for(:implementation)
        }.to change(Implementation, :count).by 1
      end
      it 'redirects to implementation' do
        post :create, idea_id: idea.id, implementation: attributes_for(:implementation)
        expect(response).to redirect_to idea_implementation_path(idea, Implementation.last)
      end
      context "for invalid attributes" do
        it 'renders new' do
          post :create, idea_id: idea.id, implementation: attributes_for(:implementation, title: '')
          expect(response).to render_template :new
        end
      end
    end
  end
end
