require 'rails_helper'

describe 'ideas index' do
  let(:user){ create :user }
  let!(:idea){ create :idea, title: 'Normal idea' }
  before { login_as user }
  describe 'regular commenting' do
    before { visit idea_path idea }
    it 'shows normal idea' do
      expect(page).to have_text('no comments')
      expect(page).to have_button('Post comment')
      expect(page).to have_field('Body')
    end
    it 'creates comment on form submit' do
      fill_in 'Body', with: 'Hello, World!'
      expect{
        click_button 'Post comment'
      }.to change(Comment, :count).by 1

      expect(page).to have_text 'Hello, World!'
    end
  end

  describe 'replying', js: true do
    let!(:replied_comment){ create :comment, commentable: idea }
    before { visit idea_path idea }
    it 'has reply link and fields' do
      within "#comment_#{ replied_comment.id }" do
        expect(page).to have_link 'reply'
        expect(page).to have_link 'flag'

        click_link 'reply'

        expect(page).to have_field('Body')
        expect(page).to have_button('Post Reply')
      end
    end
    it 'creates comment on form submit' do
      within "#comment_#{ replied_comment.id }" do
        click_link 'reply'

        fill_in 'Body', with: 'Hello, World!'
        expect{
          click_button 'Post Reply'
        }.to change(replied_comment.children, :count).by 1
      end
      expect(page).to have_text 'Hello, World!'
    end
  end
end
