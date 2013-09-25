class AddUserCommentIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :user_comment_id, :integer
  end
end
