class AddPublicToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :public, :boolean, :default => true
  end
end
