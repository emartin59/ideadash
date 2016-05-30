require 'rails_helper'

describe 'admin root page' do
  context "for admin" do
    let(:user){ create :user, admin: true }

    before { login_as user }

    it 'shows admin dashboard' do
      visit admin_root_path
      expect(page).to have_text('IdeaDash')
      expect(page).to have_text('Dashboard')
    end
  end
  context "for regular user" do
    let(:user){ create :user }

    before { login_as user }

    it 'redirects to root path' do
      visit admin_root_path
      expect(page).to have_text('ideadashbeta')
      expect(page).to have_text('ideas unleashed')
      expect(page).to have_text('You are not authorized to access this page')
      expect(page).to_not have_text('Dashboard')
    end
  end
  context "for guest user" do
    it 'redirects to root path' do
      visit admin_root_path
      expect(page).to have_text('ideadashbeta')
      expect(page).to have_text('ideas unleashed')
      expect(page).to have_text('You are not authorized to access this page')
      expect(page).to_not have_text('Dashboard')
    end
  end
end
