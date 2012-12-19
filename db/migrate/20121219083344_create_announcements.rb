class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string  :description
      t.timestamps
    end
  end
end
