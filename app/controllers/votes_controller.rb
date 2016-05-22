class VotesController < ApplicationController
  authorize_resource

  def start
    @ideas = VotingListBuilder.new(current_user).generate
  end

  def finish
    Vote.transaction do
      params[:votes].each do |vote|
        current_user.votes.create!(vote)
      end
    end
  end
end
