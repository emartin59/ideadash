require 'rails_helper'

describe Users::OmniauthCallbacksController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def stub_env_for_omniauth(provider: "facebook", uid: "1234567", email: "bob@contoso.com", name: "John Doe")
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new({ "provider" => provider,
                                                            "uid" => uid,
                                                            "info" => {
                                                                "email" => email,
                                                                "name" => name
                                                            } })
  end

  describe "facebook" do
    context "no email provided" do
      before { stub_env_for_omniauth(email: nil) }
      it "should redirect back to Facebook if email is missing" do
        get :facebook
        expect(response).to redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      end
    end
    context "no name provided" do
      before { stub_env_for_omniauth(name: '') }
      it "should not create user" do
        expect{
          get :facebook
        }.to_not change(User, :count)
      end
      it "should redirect to root" do
        get :facebook
        expect(response).to redirect_to root_path
      end
      it "should redirect to root" do
        get :facebook
        expect(flash[:warning]).to eq 'An error occured while signing up from Facebook: Name can\'t be blank'
      end
    end
    context "creates user if not present" do
      before { stub_env_for_omniauth }
      it "should redirect to root path" do
        get :facebook
        expect(response).to redirect_to root_path
      end
      it "should create user" do
        expect{
          get :facebook
        }.to change(User, :count).by(1)
      end
    end
    context "signs in user if present" do
      let!(:user){ create :user, uid: '1234567' }
      before { stub_env_for_omniauth }
      it "should redirect to root path" do
        get :facebook
        expect(response).to redirect_to root_path
      end
      it "should not create user" do
        expect{
          get :facebook
        }.to_not change(User, :count)
      end
      it "should log in user" do
        get :facebook
        expect(controller.current_user).to eq user
      end
    end
  end
  describe "google" do
    context "no email provided" do
      before { stub_env_for_omniauth(provider: 'google', email: nil) }
      it "redirects to root" do
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
    end
    context "duplicate email provided" do
      let!(:existing_user){ create :user, email: 'test@example.com' }
      before { stub_env_for_omniauth(provider: 'google', email: 'test@example.com') }
      it "redirects to root" do
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
      it "should not create user" do
        expect{
          get :google_oauth2
        }.to_not change(User, :count)
      end
    end
    context "no name provided" do
      before { stub_env_for_omniauth(provider: 'google', name: '') }
      it "should not create user" do
        expect{
          get :google_oauth2
        }.to_not change(User, :count)
      end
      it "should redirect to root" do
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
      it "should redirect to root" do
        get :google_oauth2
        expect(flash[:warning]).to eq 'An error occured while signing up from Google: Name can\'t be blank'
      end
    end
    context "creates user if not present" do
      before { stub_env_for_omniauth provider: 'google' }
      it "should redirect to root path" do
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
      it "should create user" do
        expect{
          get :google_oauth2
        }.to change(User, :count).by(1)
      end
    end
    context "signs in user if present" do
      let!(:user){ create :user, uid: '1234567' }
      before { stub_env_for_omniauth }
      it "should redirect to root path" do
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
      it "should not create user" do
        expect{
          get :google_oauth2
        }.to_not change(User, :count)
      end
      it "should log in user" do
        get :google_oauth2
        expect(controller.current_user).to eq user
      end
    end
  end
end
