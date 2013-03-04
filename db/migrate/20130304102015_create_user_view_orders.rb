class CreateUserViewOrders < ActiveRecord::Migration
  def change
    create_table :spree_user_view_orders do |t|
      t.references :user
      t.references :order
      t.timestamps
    end
  end
end
