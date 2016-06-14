require 'rails_helper'

describe 'ideas index' do
  let(:user){ create :user }
  let!(:idea){ create :idea, title: 'Normal idea' }
  let!(:spammy_idea){ create :idea, flags_count: 2, title: 'Spam here' }
  let!(:flagged_idea){ create :idea, flags_count: 8, title: 'Visit my website' }
  let!(:approved_idea){ create :idea, flags_count: 8, approved: true, title: 'Visit google' }
  before do
    login_as user
    visit ideas_path
  end
  it 'shows normal idea' do
    expect(page).to have_text(idea.title)
  end
  it 'shows spammy idea' do
    expect(page).to have_text(spammy_idea.title)
  end
  it 'does not render flagged idea' do
    expect(page).to_not have_text(flagged_idea.title)
  end
  it 'shows approved idea' do
    expect(page).to have_text(approved_idea.title)
  end
end
