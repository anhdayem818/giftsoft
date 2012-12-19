class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string  :description
      t.timestamps
    end
  end
end
