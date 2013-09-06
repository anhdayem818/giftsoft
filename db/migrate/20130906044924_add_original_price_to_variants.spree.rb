class AddOriginalPriceToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :original_price, :decimal, :null => true, :default => nil, :precision => 10, :scale => 0, :after => :sku
  end
end
