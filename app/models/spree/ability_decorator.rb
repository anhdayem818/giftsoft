module Spree
  class AbilityDecorator
    include CanCan::Ability

    def initialize(user)
      user ||= User.new
      if user.has_spree_role? "sale"
        can :manage, Order
        can :manage, Payment
        can :read, Product
        can :index, Product
        can :admin, Product
      end
    end
  end
end
Spree::Ability.register_ability(Spree::AbilityDecorator)