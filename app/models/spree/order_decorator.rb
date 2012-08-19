Spree::Order.class_eval do
  def use_billing?
    true
  end
end
