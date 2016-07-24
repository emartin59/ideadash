class VotesController < ApplicationController
  class InvalidVoteSignature < StandardError; end
  authorize_resource

  before_filter :verify_signature, only: :finish
  before_filter :verify_ds_protect, only: :finish

  def start
    @voting_list_builder = VotingListBuilder.new(current_user)
    @ideas, @signed_str = @voting_list_builder.generate
    @ds_protect = session[:ds_protect] = SecureRandom.base64
  rescue VotingListBuilder::NotEnoughIdeas
    redirect_to root_path, info: 'There are not enough ideas to vote for yet.'
  end

  def finish
    Vote.transaction do
      votes_params[:votes].each do |vote_params|
        current_user.votes.create(vote_params)
      end
    end
  end

  private
  def votes_params
    params.permit(votes: [:positive_idea_id, :negative_idea_id])
  end

  def verify_signature
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    str = crypt.decrypt_and_verify(params[:signed_str])
    skipped_idea_ids = params[:skipped_idea_ids].split(', ')
    ids = params[:votes].inject(skipped_idea_ids) do |tmp, vote|
      tmp << vote[:positive_idea_id] if vote[:positive_idea_id].present?
      tmp << vote[:negative_idea_id] if vote[:negative_idea_id].present?
      tmp
    end
    provided_str = ids.map(&:to_i).reduce(:*)
    raise InvalidVoteSignature, 'Signature provided is invalid' unless str == provided_str
  rescue ActiveSupport::MessageVerifier::InvalidSignature, InvalidVoteSignature
    redirect_to start_votes_path, danger: 'Signature provided is invalid. Please, try again.'
  end

  def verify_ds_protect
    ds_protect = session.delete(:ds_protect)
    return true if params[:ds_protect].present? && ds_protect == params[:ds_protect]
    redirect_to root_path, info: 'This voting has already been submitted.'
  end
end
