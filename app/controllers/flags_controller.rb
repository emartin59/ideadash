class FlagsController < ApplicationController
  load_resource :idea
  authorize_resource :flag

  def create
    @flag = current_user.flags.build(flag_params)
    puts @idea.id
    if @flag.save
      @message = 'Thank you for reporting! We will review this report as soon as possible'
    else
      @message = 'There was an error processing your report. Please, try again'
    end
    respond_to do |format|
      format.html { redirect_to @idea, info: @message }
      format.js
    end
  end

  private

    def flag_params
      params.require(:flag).permit(:kind, :description).merge(flaggable: @idea)
    end
end
