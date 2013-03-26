class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
