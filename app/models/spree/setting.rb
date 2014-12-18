class Spree::Setting < ActiveRecord::Base
  self.table_name = "settings"
  attr_accessible :posts_per_day
end
