class MainController < ApplicationController
  skip_authorization_check

  def index
    @subscriber = Subscriber.new
  end

  def subscribe
    @subscriber = Subscriber.new(email: params[:subscriber][:email])
    respond_to do |format|
      if @subscriber.save
        @status = :success
        @message = 'Thanks for subscribing!'
      else
        @status = :info
        @message = @subscriber.errors[:email].join
      end
      format.js
      format.html { redirect_to root_path, @status => @message }
    end
  end

  def letsencrypt
    render text: 'UbCdFEh8G_VlbCXa9Ma-jrowj-gsvUdnin2zLz9LqEc.RxQRd4Fobz-EYXXu2uCEebPb8NjiQNF8r1w4uX0Jxwc'
  end
end
