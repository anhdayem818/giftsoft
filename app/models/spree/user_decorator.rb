# Default implementation of User.  This class is intended to be modified by extensions (ex. spree_auth_devise)
Spree::User.class_eval do
  attr_accessible :username
  validates :username, :presence => true, :uniqueness => true
end
