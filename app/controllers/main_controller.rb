class MainController < ApplicationController
  skip_authorization_check

  def index
    @ideas = Idea.current.safe_order(:rating).limit(6) if user_signed_in?
  end

  def terms
  end

  def privacy_policy
  end

  def about
  end

  def contest
  end

  def search
  end

  def letsencrypt
    render text: 'WYPUBmuNdE8H8DWR03bj2QPerfNGIa2AYW3XpdLiYQU.RxQRd4Fobz-EYXXu2uCEebPb8NjiQNF8r1w4uX0Jxwc'
  end
end
