require 'rails_helper'

RSpec.describe BackerVote, type: :model do
  subject { build :backer_vote }

  describe "valid factory" do
    let(:user){ create :user, balance: 10 }
    let(:idea){ create :idea }
    before { create :payment, sender: user, recipient: idea, amount: 5 }
    subject { build :backer_vote, user: user, idea: idea }

    it { is_expected.to be_valid }
  end

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :idea }
  it { is_expected.to belong_to :idea }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :implementation }
end
