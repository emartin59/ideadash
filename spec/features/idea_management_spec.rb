require 'rails_helper'

describe 'idea creation' do
  let(:user){ create :user }
  before { login_as user }
  it 'shows idea form' do
    visit new_idea_path
    expect(page).to have_text('Post an idea')
    expect(page).to have_field 'Title'
    expect(page).to have_field 'Summary'
    expect(page).to have_field 'Description'
    expect(page).to have_field 'I accept Terms of Service and understand that by posting my idea anyone will be able to use it or implement it.'
  end
  it 'accepts idea submission' do
    visit new_idea_path
    idea = build :idea
    fill_in 'Title', with: idea.title
    fill_in 'Summary', with: idea.summary
    fill_in 'Description', with: idea.description
    check('idea_tos_accepted')
    expect{
      click_button 'Post Idea'
    }.to change(Idea, :count).by 1
    expect(page).to have_text idea.title
    expect(page).to have_text 'Idea was successfully created'
  end
end

describe "idea editing" do
  let(:user){ create :user }
  before { login_as user }
  let!(:idea){ create :idea, user: user }
  it 'shows idea form' do
    visit user_ideas_path(user)
    expect(page).to have_text idea.title
  end
  it 'accepts idea submission' do
    visit edit_idea_path(idea)
    fill_in 'Title', with: 'New Idea Title'
    fill_in 'Summary', with: 'New Idea Summary'
    fill_in 'Description', with: 'New Idea Description'
    expect{
      click_button 'Update Idea'
    }.to change{idea.reload.title}.from(idea.title).to('New Idea Title')
    expect(page).to have_text 'New Idea Title'
    expect(page).to have_text 'Idea was successfully updated'
  end
end

describe "idea removal" do
  let(:user){ create :user }
  before { login_as user }
  let!(:idea){ create :idea, user: user }
  it 'deletes idea' do
    visit user_ideas_path(user)
    within("#idea_#{idea.id}") do
      expect(page).to have_text idea.title
      expect{
        click_link 'Delete'
      }.to change(Idea, :count).by(-1)
    end
  end
end
