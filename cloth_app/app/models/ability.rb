class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.is? :admin
      can :manage, :all
    else

      can :read,    Address if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :create,  Address if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :update,  Address if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :destroy, Address if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)

      can :read,    Category if (user.is? :admin)
      can :create,  Category if (user.is? :admin)
      can :update,  Category if (user.is? :admin)
      can :destroy, Category if (user.is? :admin)
      can :search,  Category if (user.is? :admin)

      can :read,    Content if (user.is? :admin) || (user.is? :publisher)
      can :create,  Content if (user.is? :admin) || (user.is? :publisher)
      can :update,  Content if (user.is? :admin) || (user.is? :publisher)
      can :publish, Content if (user.is? :admin) || (user.is? :publisher)
      can :destroy, Content if (user.is? :admin) || (user.is? :publisher)

      can :read,    Order if (user.is? :premium) || (user.is? :admin)
      can :create,  Order if (user.is? :premium) || (user.is? :admin)
      can :update,  Order if (user.is? :premium) || (user.is? :admin)
      can :destroy, Order if (user.is? :premium) || (user.is? :admin)
      can :search,  Order if (user.is? :premium) || (user.is? :admin)

      can :read,    Package 
      can :create,  Package if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :update,  Package if (user.is? :registered) || (user.is? :premium) || (user.is? :admin) 
      can :destroy, Package if (user.is? :admin)
      can :show,    Package if (user.is? :premium) || (user.is? :admin)
      can :search,  Package if (user.is? :guest) || (user.is? :registered) || (user.is? :premium) || (user.is? :admin)

      can :read,    Payment if (user.is? :admin)
      can :create,  Payment if (user.is? :admin)
      can :update,  Payment if (user.is? :admin)
      can :destroy, Payment if (user.is? :admin)
      can :search,  Payment if (user.is? :admin)

      can :read,    Price if (user.is? :admin)
      can :create,  Price if (user.is? :admin)
      can :update,  Price if (user.is? :admin)
      can :destroy, Price if (user.is? :admin)
      can :search,  Price if (user.is? :admin)

      can :read,    Profile if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :create,  Profile if (user.is? :admin)
      can :update,  Profile if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :destroy, Profile if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)
      can :search,  Profile if (user.is? :registered) || (user.is? :premium) || (user.is? :admin)



#      can :update, Content do |content|
#        content.try(:user) == user || (user.is? :publisher)
#      end
      
    end
  end
  
end