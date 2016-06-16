class ImplementationsController < ApplicationController
  load_resource :idea
  load_and_authorize_resource :implementation, through: :idea

  def index
    @implementations = @implementations.paginate(:page => params[:page])
  end

  def show
  end

  def new
  end

  def create
    if @implementation.save
      redirect_to [@idea, @implementation], success: 'Your implementation proposal has been posted successfully.'
    else
      render :new
    end
  end

  private

  def implementation_params
    params.require(:implementation).permit(:title, :summary, :description, :tos_accepted)
  end
end
