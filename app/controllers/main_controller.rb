class MainController < ApplicationController
  def index
    @subscriber = Subscriber.new
  end

  def subscribe
    Subscriber.create(email: params[:subscriber][:email])
  end
end
