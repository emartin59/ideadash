require 'rails_helper'

describe 'root page' do
  it 'shows project name and slogan there' do
    visit root_path
    expect(page).to have_text('ideadashbeta')
    expect(page).to have_text('Learn how it works in ~1.8 minutes')
  end

  describe 'facebook sign in' do
    context 'for new user' do
      let(:user){ build :user }
      before { mock_user(user) }
      it 'shows success message' do
        visit root_path
        find(:css, '.btn.btn-facebook').click
        expect(page).to have_text 'Successfully authenticated from Facebook account.'
        expect(page).to have_text "Welcome, #{user.name}"
      end
      it 'creates user' do
        visit root_path
        expect{
          find(:css, '.btn.btn-facebook').click
        }.to change(User, :count).by(1)
      end
    end
    context 'for existing user' do
      let(:user){ create :user }
      before { mock_user(user) }
      it 'shows success message' do
        visit root_path
        find(:css, '.btn.btn-facebook').click
        expect(page).to have_text 'Successfully authenticated from Facebook account.'
        expect(page).to have_text "Welcome, #{user.name}"
      end
      it 'does not create user' do
        visit root_path
        expect{
          find(:css, '.btn.btn-facebook').click
        }.to_not change(User, :count)
      end
    end
  end
end
