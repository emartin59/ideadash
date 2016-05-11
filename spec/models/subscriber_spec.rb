require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  subject { build :subscriber }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:email).with_message 'Please fill in the email field.' }
  it { is_expected.to validate_uniqueness_of(:email).with_message('You are already subscribed!') }
end
