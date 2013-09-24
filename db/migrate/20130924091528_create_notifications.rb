class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer  :user_id
      t.integer :notificationable_id
      t.string  :notificationable_type
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
