class Article < ActiveRecord::Base
  attr_accessible :content, :title, :short_desc, :permalink
  def to_param
    "#{self.id}-#{self.permalink}"
  end
end
