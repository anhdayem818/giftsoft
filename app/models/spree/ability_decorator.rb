module Spree
  class AbilityDecorator
    include CanCan::Ability

    def initialize(user)
      user ||= User.new
      if user.has_spree_role? "sale"
        can :manage, Adjustment
        can :manage, Order
        can :manage, LineItem
        can :manage, Payment
        can :manage, Shipment
        can :read, Product
        can :index, Product
        can :admin, Product
        can :index, Variant
        can :admin, Variant
      end
      if user.has_spree_role? "admin"
        can :manage, Instruction
      end
    end
  end
end
Spree::Ability.register_ability(Spree::AbilityDecorator)