OmniAuth.config.test_mode = true

module OmniAuthSupport
  def mock_user(user)
    OmniAuth.config.add_mock(:facebook, {
        provider: user.provider,
        uid:      user.uid,
        info:     {
            name:  user.name,
            email: user.email
        }
    })
  end
end

RSpec.configure do |config|
  config.after :each do
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  config.include OmniAuthSupport, type: :feature
end
