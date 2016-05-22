class VotesController < ApplicationController
  authorize_resource

  def start
    @ideas = VotingListBuilder.new(current_user).generate
  end

  def finish
    Vote.transaction do
      votes_params[:votes].each do |vote|
        current_user.votes.create!(vote)
      end
    end
  end

  private
  def votes_params
    params.permit(votes: [:positive_idea_id, :negative_idea_id])
  end
end
