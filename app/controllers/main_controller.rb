class MainController < ApplicationController
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
end
