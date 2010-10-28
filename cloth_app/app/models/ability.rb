class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.is? :admin
      can :manage, :all
    else
      can :read,    Content if (user.is? :admin) || (user.is? :publisher)
      can :create,  Content if (user.is? :admin) || (user.is? :publisher)
      can :update,  Content if (user.is? :admin) || (user.is? :publisher)
      can :destroy, Content if (user.is? :admin) || (user.is? :publisher)

      can :read,    Package if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :create,  Package if (user.is? :base) || (user.is? :premium) || (user.is? :admin)
      can :update,  Package if (user.is? :base) || (user.is? :premium) || (user.is? :admin)
      can :destroy, Package if (user.is? :admin)
      can :search,  Package if (user.is? :guest) || (user.is? :registered) || (user.is? :based) || (user.is? :premium)

#      can :update, Content do |content|
#        content.try(:user) == user || (user.is? :publisher)
#      end
      
    end
  end
  
end