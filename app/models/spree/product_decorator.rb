Spree::Product.class_eval do
  acts_as_commentable
  attr_accessible :short_desc
  def in_process
    has_variants? ? variants.sum(&:in_process) : master.in_process
  end
end