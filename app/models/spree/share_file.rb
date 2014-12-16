class Spree::ShareFile < ActiveRecord::Base
  self.table_name = "share_files"
  attr_accessible :attachment

  mount_uploader :attachment, ShareFileUploader
end
