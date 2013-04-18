class Announcement < ActiveRecord::Base
  attr_accessible :description, :popup
  scope :notices, lambda { where(:popup => true ) }
  scope :not_notices, lambda { where(:popup => false ) }
end
