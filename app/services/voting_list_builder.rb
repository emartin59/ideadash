class VotingListBuilder
  class NotEnoughIdeas < StandardError; end

  def initialize(current_user)
    @current_user = current_user
  end

  def generate
    validate_counts
    return build_ideas, signed_str
  end

  def current_ideas
    @current_ideas ||= Idea.visible.current.where('user_id != ?', @current_user.id).unscope(:order)
                           .order('(positive_votes_count + negative_votes_count) ASC').limit(5)
  end

  def all_ideas
    @all_ideas ||= Idea.visible.where('id NOT IN(?) AND user_id != ?', current_ideas_ids, @current_user.id).unscope(:order).order('random()').limit(5)
  end

  def current_ideas_ids
    current_ideas.map(&:id)
  end

  def all_ideas_ids
    all_ideas.map(&:id)
  end

  def signed_str
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    str = current_ideas_ids.zip(all_ideas_ids).map{|x, y| x * y}.join
    crypt.encrypt_and_sign(str)
  end

  def build_ideas
    ideas = []
    current_ideas.each_index do |i|
      ideas.push [current_ideas[i], all_ideas[i]]
    end
    ideas
  end

  def validate_counts
    return if current_ideas.length == 5 && all_ideas.length == 5
    raise NotEnoughIdeas
  end
end
