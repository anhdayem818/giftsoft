class Article < ActiveRecord::Base
  attr_accessible :content, :title, :short_desc
end
