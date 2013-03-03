Spree::Variant.class_eval do
  def in_process
    line_items.joins(:order).where("spree_orders.state = 'complete' AND spree_orders.payment_state <> 'paid'").sum(:quantity)
  end
end