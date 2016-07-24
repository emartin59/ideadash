require 'rails_helper'

describe 'idea creation', js: true do
  let(:user){ create :user }
  let(:other_user){ create :user }
  before do
    login_as user
    create_list :idea, 10, user: other_user
  end
  it 'shows idea form' do
    visit start_votes_path
    expect(page).to have_text('Select the idea you prefer')

    expect(page).to have_text("1/5")
    expect(page).to have_css('.vote-select')
    click_button 'Skip'

    # we walk from first till last page
    (2..4).each do |i|
      expect(page).to have_text("#{i}/5")
      expect(page).to have_css('.vote-select')
      first('.voted-idea').click
      click_button 'Next'
    end

    # then go back by one
    click_button 'Back'
    all('.voted-idea').last.click

    # then go forward again
    click_button 'Next'

    # then submit results
    first('.voted-idea').click
    expect{
      click_button 'Save Votes'
    }.to change(Vote, :count).by 4 # we have one skipped
    expect(page).to have_text 'For diligently rating 5 sets of ideas, you\'ve just earned 1 dashNut. Congratulations!'
  end
end
