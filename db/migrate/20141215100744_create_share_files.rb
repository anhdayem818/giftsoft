class CreateShareFiles < ActiveRecord::Migration
  def change
    create_table :share_files do |t|
      t.string :attachment

      t.timestamps
    end
  end
end
