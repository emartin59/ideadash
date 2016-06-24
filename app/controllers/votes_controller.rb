class VotesController < ApplicationController
  class InvalidVoteSignature < StandardError; end
  authorize_resource

  before_filter :verify_signature, only: :finish
  before_filter :verify_ds_protect, only: :finish

  def start
    @ideas, @signed_str = VotingListBuilder.new(current_user).generate
    @ds_protect = session[:ds_protect] = SecureRandom.base64
  rescue VotingListBuilder::NotEnoughIdeas
    redirect_to root_path, info: 'There are not enough ideas to vote for yet.'
  end

  def finish
    Vote.transaction do
      votes_params[:votes].each do |vote|
        current_user.votes.create(vote)
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
    provided_str = params[:votes].inject([]){|tmp, vote| tmp << (vote[:positive_idea_id].to_i * vote[:negative_idea_id].to_i) }.join
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
