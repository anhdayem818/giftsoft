class AddShortDescToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :short_desc, :string
  end
end
