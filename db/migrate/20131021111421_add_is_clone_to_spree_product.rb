class AddIsCloneToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_clone, :boolean, :default => false
  end
end
