Spree::Product.class_eval do
  acts_as_commentable
  def in_process
    has_variants? ? variants.sum(&:in_process) : master.in_process
  end
end