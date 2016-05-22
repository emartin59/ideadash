class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Idea
    can :read, User
    can :read, :main

    if user.persisted?
      can :manage, Idea, { user_id: user.id }
      cannot [:edit, :destroy], Idea do |idea|
        idea.positive_votes_count * 3 > idea.negative_votes_count
      end
      can :manage, Vote
    end
  end
end
