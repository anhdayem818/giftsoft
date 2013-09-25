class AddCouponToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :coupon, :string
  end
end
