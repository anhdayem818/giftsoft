Spree::Variant.class_eval do
  attr_accessible :original_price
  after_update :update_price_all_variants

  def in_process
    line_items.joins(:order).where("spree_orders.state = 'complete' AND spree_orders.payment_state <> 'paid'").sum(:quantity)
  end
  
  def sole_out(start_date = Time.now, end_date = Time.now)
    line_items.joins(:order).where(:spree_orders => {:state => 'complete', :payment_state => 'paid', :paid_at => start_date..end_date})
    .sum(:quantity)
  end


  private
  def update_price_all_variants
    if self.is_master? && product.present? && product.variants.present?
      product = self.product
      product.variants.update_all(price: self.price)
    end

    #if self.is_master?
    #  product = self.product
    #  product.variants.update_all(price: self.price) if product.present? && product.variants.present?
    #end
  end
end