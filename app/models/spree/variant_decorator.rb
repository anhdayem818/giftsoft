Spree::Variant.class_eval do
  def in_process
    line_items.joins(:order).where("spree_orders.state = 'complete' AND spree_orders.payment_state <> 'paid'").sum(:quantity)
  end
  
  def sole_out(start_date = Time.now, end_date = Time.now)
    line_items.joins(:order).where(:spree_orders => {:state => 'complete', :payment_state => 'paid', :paid_at => start_date..end_date})
    .sum(:quantity)
  end
end