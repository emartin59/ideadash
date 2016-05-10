require 'rails_helper'

describe 'root page' do
  it 'shows project name and slogan there' do
    visit root_path
    expect(page).to have_text('IdeaDash')
    expect(page).to have_text('ideas unleashed')
  end

  describe 'subscription process' do
    it 'shows subscribe form' do
      visit root_path
      expect(page).to have_text 'submit your email below and be among the first'
      expect(page).to have_text 'to be invited to our launch'
      expect(page).to have_field 'subscriber_email'
      expect(page).to have_button 'Subscribe'
    end

    it 'shows success flash when form is submitted' do
      visit root_path
      fill_in 'subscriber_email', with: build(:subscriber).email
      click_button 'Subscribe'
      expect(page).to have_text 'Thanks for subscribing!'
    end
  end

  describe 'subscription process with JS', js: true do
    it 'shows subscribe form' do
      visit root_path
      expect(page).to have_text 'submit your email below and be among the first'
      expect(page).to have_text 'to be invited to our launch'
      expect(page).to have_field 'subscriber_email'
      expect(page).to have_button 'Subscribe'
    end

    it 'shows success flash when form is submitted' do
      visit root_path
      fill_in 'subscriber_email', with: build(:subscriber).email
      click_button 'Subscribe'
      expect(page).to have_text 'Thanks for subscribing!'
    end
  end

  describe 'facebook sign in' do
    context 'for new user' do
      let(:user){ build :user }
      before { mock_user(user) }
      it 'shows success message' do
        visit root_path
        click_link 'Login with Facebook'
        expect(page).to have_text 'Successfully authenticated from Facebook account.'
        expect(page).to have_text "Welcome, #{user.name}"
      end
      it 'creates user' do
        visit root_path
        expect{
          click_link 'Login with Facebook'
        }.to change(User, :count).by(1)
      end
    end
    context 'for existing user' do
      let(:user){ create :user }
      before { mock_user(user) }
      it 'shows success message' do
        visit root_path
        click_link 'Login with Facebook'
        expect(page).to have_text 'Successfully authenticated from Facebook account.'
        expect(page).to have_text "Welcome, #{user.name}"
      end
      it 'does not create user' do
        visit root_path
        expect{
          click_link 'Login with Facebook'
        }.to_not change(User, :count)
      end
    end
  end
end
