class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Idea
    can :read, User
    can :read, Implementation
    can :read, :main

    if user.persisted? && user.active
      can :manage, Idea, { user_id: user.id }
      can :manage, Payment
      cannot [:edit, :destroy], Idea do |idea|
        idea.positive_votes_count * 3 > idea.negative_votes_count || idea.balance > 0
      end
      can(:manage, Vote) if user.more_votes_allowed?
      can :create, Flag
      can :manage, Implementation, { user_id: user.id }

      cannot :create, Implementation do |implementation|
        Implementation.where(user_id: user.id, idea_id: implementation.idea_id).present? || !implementation.idea.in_proposals_phase?
      end
    end
  end
end
