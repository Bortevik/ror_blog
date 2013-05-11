class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    else
      can :read, Post
      can [:create, :activate], User
      can [:update, :show, :destroy], User do |user_model|
        user_model == user
      end
    end
  end
end
