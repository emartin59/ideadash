class VotesController < ApplicationController
  authorize_resource

  def start
    @ideas = VotingListBuilder.new(current_user).generate
  end

  def finish
  end
end
