class AddPostedToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :posted, :boolean, :default => false
  end
end
