require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe "#from_omniauth" do
    let(:info){ instance_double('Info', email: subject.email, name: subject.name) }
    let(:auth){ instance_double('Auth', provider: 'facebook', uid: Faker::Code.ean, info: info) }

    context "when user doesn't exist" do
      it 'creates new user' do
        expect{
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)
      end
      it 'assigns credentials to user' do
        user = User.from_omniauth(auth)
        expect(user.email).to eq subject.email
        expect(user.name).to eq subject.name
      end
    end
    context "when user exists" do
      let!(:user){ create :user, uid: auth.uid, name: info.name, email: info.email }

      it 'does not create new user' do
        expect{
          User.from_omniauth(auth)
        }.to_not change(User, :count)
      end
      it 'returns user' do
        expect(User.from_omniauth(auth)).to eq user
      end
    end
  end
end
