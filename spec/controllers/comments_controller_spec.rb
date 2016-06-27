require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user){ create :user }
  let(:idea){ create :idea }
  before do
    sign_in user
    request.env["HTTP_REFERER"] = idea_path(idea)
  end
  describe "POST #create" do
    context "for root comment" do
      it 'returns success' do
        post :create, { comment: attributes_for(:comment), idea_id: idea.id }
        expect(response).to redirect_to idea_path(idea)
      end
      it 'creates comment' do
        expect{
          post :create, { comment: attributes_for(:comment), idea_id: idea.id }
        }.to change(Comment, :count).by 1
      end
      context "when invalid" do
        it 'does not create comment' do
          expect{
            post :create, { comment: attributes_for(:comment, body: ''), idea_id: idea.id }
          }.to_not change(Comment, :count)
        end
      end
    end
    context "for child comment" do
      let!(:parent_comment){ create :comment, commentable: idea }
      it 'returns success' do
        post :create, { comment: attributes_for(:comment, comment_id: parent_comment.id), idea_id: idea.id }
        expect(response).to redirect_to idea_path(idea)
      end
      it 'creates comment' do
        expect{
          post :create, { comment: attributes_for(:comment, comment_id: parent_comment.id), idea_id: idea.id }
        }.to change(Comment, :count).by 1
      end
      it 'creates child comment' do
        expect{
          post :create, { comment: attributes_for(:comment, comment_id: parent_comment.id), idea_id: idea.id }
        }.to change(parent_comment, :has_children?).from(false).to true
      end
    end
  end
end
