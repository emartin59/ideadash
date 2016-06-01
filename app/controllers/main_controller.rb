class MainController < ApplicationController
  skip_authorization_check

  def index
  end

  def terms
  end

  def privacy_policy
  end

  def about
  end

  def letsencrypt
    render text: 'EDRa5RfvqS71twzPAfvzzAcnNSi4BhaalAld5Y5SVHQ.RxQRd4Fobz-EYXXu2uCEebPb8NjiQNF8r1w4uX0Jxwc'
  end
end
