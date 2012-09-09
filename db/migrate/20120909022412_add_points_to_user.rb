class AddPointsToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :point, :integer, :default => 0
  end
end
