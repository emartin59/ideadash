require 'rails_helper'

RSpec.describe Flag, type: :model do
  subject{ build :flag }

  it{ is_expected.to be_valid }
  it{ is_expected.to belong_to :user }
  it{ is_expected.to belong_to :flaggable }
end
