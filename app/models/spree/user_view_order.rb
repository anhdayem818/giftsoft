module Spree
  class UserViewOrder < ActiveRecord::Base
    attr_accessible :order
    belongs_to :user
    belongs_to :order
  end
end
