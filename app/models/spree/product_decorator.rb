Spree::Product.class_eval do
  acts_as_commentable
  attr_accessible :short_desc, :original_price, :pirce, :is_clone
  delegate_belongs_to :master, :original_price

  has_many :notifications, :as => :notificationable

  def in_process
    has_variants? ? variants.sum(&:in_process) : master.in_process
  end
  
  def sole_out(start_date = 7.days.ago, end_date = Time.now)
    has_variants? ? variants.sum(&:sole_out) : master.sole_out(start_date, end_date)
  end
  
  def self.not_deleted
    where('spree_products.deleted_at IS NULL')
  end

  def self.available
    where('spree_products.available_on IS NOT NULL')
  end
  
  def show_in_report?(start_date = 7.days.ago, end_date = Time.now)
    sole_out(start_date, end_date) != 0 || in_process != 0 || on_hand != 0
  end
  
  def resume
    self.update_column(:deleted_at, nil)
    variants_including_master_and_deleted.update_all(:deleted_at => nil)
  end
end