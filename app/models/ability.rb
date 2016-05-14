class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Idea
    can :read, :main

    if user.persisted?
      can :manage, Idea, { user_id: user.id }
    end
  end
end
