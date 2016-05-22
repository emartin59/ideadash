class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :danger, :info, :warning, :success

  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied, with: :access_denied

  private
  def authenticate_admin_user!
    raise CanCan::AccessDenied.new('You are not authorized to access this page') unless user_signed_in? && current_user.admin
  end

  def access_denied(exception)
    redirect_to root_url, :danger => exception.message
  end
end
