class AddPopupToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :popup, :boolean
  end
end
