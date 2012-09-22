class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string :title
      t.text :content
      t.string :short_desc
      t.timestamps
    end
  end
end
