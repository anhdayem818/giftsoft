module Spree
  module Admin
    OrdersController.class_eval do
      def show
        current_user.user_view_orders.create(:order => @order)
        respond_with(@order)
      end
    end
  end
end
