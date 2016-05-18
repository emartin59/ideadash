require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build :vote }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :positive_idea }
  it { is_expected.to belong_to :negative_idea }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :positive_idea }
  it { is_expected.to validate_presence_of :negative_idea }
end
