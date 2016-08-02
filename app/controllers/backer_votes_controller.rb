class BackerVotesController < ApplicationController
  load_resource :idea
  before_action :find_or_initialize_backer_vote
  load_and_authorize_resource :backer_vote, through: :idea

  def new
  end

  def create
    @backer_vote.assign_attributes(backer_vote_params)
    if @backer_vote.save
      redirect_to @idea, success: 'Your have voted successfully!'
    else
      render :new
    end
  end

  private
  def backer_vote_params
    paras = params.require(:backer_vote).permit(:kind)
    paras.merge!(implementation_id: params[:backer_vote][:implementation_id]) if @backer_vote.kind == 'vote'
    paras
  end

  def find_or_initialize_backer_vote
    @backer_vote = BackerVote.find_or_initialize_by(user_id: current_user.id, idea_id: @idea.id)
  end
end
