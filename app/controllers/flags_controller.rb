class FlagsController < ApplicationController
  load_resource :idea
  load_resource :comment
  authorize_resource :flag

  def create
    @flag = current_user.flags.build(flag_params)
    if @flag.save
      @message = 'Thank you for reporting! We will review this report as soon as possible'
    else
      @message = 'You have already reported this issue'
    end
    respond_to do |format|
      format.html { redirect_to @idea, info: @message }
      format.js
    end
  end

  private

    def flag_params
      params.require(:flag).permit(:kind, :description).merge(flaggable: @idea.presence || @comment.presence)
    end
end
