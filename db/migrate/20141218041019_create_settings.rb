class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :posts_per_day, :default => 2

      t.timestamps
    end
    Spree::Setting.create
  end
end
