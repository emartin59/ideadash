require 'single_sign_on'

class DiscourseSsoController < ApplicationController
  before_filter :ensure_authentication

  def sso
    secret = ENV['DISCOURSE_SSO_SECRET']
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = current_user.email
    sso.name = current_user.name
    sso.username = current_user.name.downcase.split(' ').join('.').gsub(/(.+)\.(\w)\w+/, '\1.\2')
    sso.external_id = current_user.id
    sso.sso_secret = secret

    redirect_to sso.to_url("http://forum.ideadash.com/session/sso_login")
  end

  private

  def ensure_authentication
    return true if user_signed_in?
    cookies[:discourse] = { value: request.fullpath, expires: 10.minutes.from_now }
    redirect_to root_path, warning: 'You need to sign in first.'
  end
end
