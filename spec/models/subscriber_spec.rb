require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  subject { build :subscriber }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email) }
end
