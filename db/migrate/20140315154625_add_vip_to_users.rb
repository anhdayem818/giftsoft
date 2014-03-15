class AddVipToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :vip, :boolean, :default => false
  end
end
