class MainController < ApplicationController
  def index
    @subscriber = Subscriber.new
  end

  def subscribe
    Subscriber.create(email: params[:subscriber][:email])
    respond_to do |format|
      format.js
      format.html { redirect_to root_path, success: 'Thanks for subscribing!' }
    end
  end
end
