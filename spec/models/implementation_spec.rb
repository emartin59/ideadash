require 'rails_helper'

RSpec.describe Implementation, type: :model do
  subject { build :implementation }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :idea }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :summary }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :idea }
end
