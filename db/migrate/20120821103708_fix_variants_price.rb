class FixVariantsPrice < ActiveRecord::Migration
  def up
    change_column :spree_variants, :price, :decimal, :precision => 10, :scale => 0
  end

  def down
  end
end
