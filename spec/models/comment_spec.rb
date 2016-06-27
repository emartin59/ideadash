require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:commentable){ build :idea }
  let(:user){ build :user }
  subject(:comment){ build :comment, commentable: commentable, user: user }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:user) }

  describe ".find_commentable" do
    before { commentable.save }
    let(:result){ Comment.find_commentable('Idea', commentable.id) }

    it 'returns commentable by provided credentials' do
      expect(result).to eq commentable
    end
  end

  describe ".build_from" do
    before do
      commentable.save
      user.save
    end
    subject { Comment.build_from commentable, user.id, 'Hello world!' }
    it { is_expected.to be_kind_of Comment }
    it 'has user assigned' do
      expect(subject.user).to eq user
    end
    it 'has commentable assigned' do
      expect(subject.commentable).to eq commentable
    end
    it 'has body assigned' do
      expect(subject.body).to eq 'Hello world!'
    end
  end

  describe ".find_comments_by_user" do
    before do
      user.save
      comment.save
    end
    let(:other_comment){ create :comment, commentable: commentable }
    subject(:result){ Comment.find_comments_by_user user }
    it { is_expected.to match_array [comment] }
  end

  describe ".find_comments_for_commentable" do
    before do
      user.save
      comment.save
    end
    let(:other_comment){ create :comment, user: user }
    subject(:result){ Comment.find_comments_for_commentable 'Idea', commentable.id }
    it { is_expected.to match_array [comment] }
  end

  describe "#has_children?" do
    context "for comment with no children" do
      subject(:result){ comment.has_children? }
      it 'returns false' do
        expect(result).to be_falsey
      end
    end
    context "for comment with children" do
      before do
        user.save
        comment.save
        comment_2 = Comment.build_from commentable, user.id, 'Goodbye!'
        comment_2.save
        comment_2.move_to_child_of comment
      end
      subject(:result){ comment.has_children? }
      it 'returns true' do
        expect(result).to be_truthy
      end
    end
  end
end
