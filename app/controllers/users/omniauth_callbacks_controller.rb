class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      return redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
    end

    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      redirect_to root_path, warning: "An error occured while signing up from Facebook: #{ @user.errors.full_messages.join(', ') }"
    end
  end

  def failure
    redirect_to root_path, warning: failure_message
  end
end