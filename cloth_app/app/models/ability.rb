class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage,  :all if user.is? :admin
    can :write,   :all if user.is? :publisher
    can :read,    :all if user.is? [:base, :publisher, :premium ]
    can :search,  :all if user.is? :premium
  end
end