class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.is? :admin
      can :manage, :all
    else
      can :read, Content if (user.is? :admin) || (user.is? :publisher)

      can :create, Content if (user.is? :admin) || (user.is? :publisher)

      can :update, Content if (user.is? :admin) || (user.is? :publisher)

      can :destroy, Content if (user.is? :admin) || (user.is? :publisher)

#      can :update, Content do |content|
#        content.try(:user) == user || (user.is? :publisher)
#      end
      
    end
  end
  
end