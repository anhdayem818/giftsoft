# Default implementation of User.  This class is intended to be modified by extensions (ex. spree_auth_devise)
module Spree
  User.class_eval do
    attr_accessible :username
    validates :username, :presence => true, :uniqueness => true
    def viewed?(order)
      Spree::UserViewOrder.exists?(["user_id =? AND order_id = ?", id, order.id])
    end
    has_many :user_view_orders
    
    def admin_group?
      has_spree_role?("admin") || has_spree_role?("sale")
    end
    
    def vip?
      orders.select(&:paid?).sum(&:total) > 1000000
    end
  end
end
