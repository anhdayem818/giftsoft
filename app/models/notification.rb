class Notification < ActiveRecord::Base
  attr_accessible :user_id, :notificationable_id, :notificationable_type, :read

  belongs_to :notificationable, :polymorphic => true
  belongs_to :user, :class_name => "Spree::User"
  scope :unread, where(:read => false)

  def read!
    self.update_attributes(:read => true)
  end
end
