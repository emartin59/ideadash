require 'rails_helper'

RSpec.describe Idea, type: :model do
  subject { build :idea }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:positive_votes).with_foreign_key(:positive_idea_id) }
  it { is_expected.to have_many(:negative_votes).with_foreign_key(:negative_idea_id) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_uniqueness_of :title }
  it { is_expected.to validate_presence_of :summary }
  it { is_expected.to validate_length_of :summary }
  it { is_expected.to validate_presence_of :user }
end
