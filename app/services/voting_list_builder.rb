class VotingListBuilder
  def initialize(current_user)
    @current_user = current_user
  end

  def generate
    ideas = []
    current_ideas.each_index do |i|
      ideas.push current: current_ideas[i], all: all_ideas[i]
    end
    ideas
  end

  def current_ideas
    @current_ideas ||= Idea.current.where('user_id != ?', @current_user.id).order(created_at: :desc).limit(5)
  end

  def all_ideas
    @all_ideas ||= Idea.where('id NOT IN(?) AND user_id != ?', current_ideas.map(&:id), @current_user.id).order('random()')
  end
end
