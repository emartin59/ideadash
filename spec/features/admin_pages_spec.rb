require 'rails_helper'

describe 'admin root page' do
  include ApplicationHelper

  context "for admin" do
    let(:user){ create :user, admin: true }

    before { login_as user }

    it 'shows admin dashboard' do
      visit send("#{ active_admin }_root_path")
      expect(page).to have_text('IdeaDash')
      expect(page).to have_text('Dashboard')
    end
  end
  context "for regular user" do
    let(:user){ create :user }

    before { login_as user }

    it 'redirects to root path' do
      visit send("#{ active_admin }_root_path")
      expect(page).to have_text('ideadashbeta')
      expect(page).to have_text('Wondering what to do?')
      expect(page).to have_text('You are not authorized to access this page')
      expect(page).to_not have_text('Dashboard')
    end
  end
  context "for guest user" do
    it 'redirects to root path' do
      visit send("#{ active_admin }_root_path")
      expect(page).to have_text('ideadashbeta')
      expect(page).to have_text('Learn how it works and about this month\'s $1,000 contest in 1.8 minutes')
      expect(page).to have_text('You are not authorized to access this page')
      expect(page).to_not have_text('Dashboard')
    end
  end
end
