Spree::Order.class_eval do
  #has_many :line_items, :dependent => :destroy, :class_name => "Spree::LineItem"
  def add_variant(variant, quantity = 1)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      if(current_item.quantity > variant.on_hand)
        return nil
      end
      current_item.save
    else
      current_item = Spree::LineItem.new(:quantity => quantity)
      current_item.variant = variant
      current_item.price   = variant.price
      self.line_items << current_item
    end

    self.reload
    current_item
  end
  
  def validate_total
    self.item_total >= 200000
  end
  
  def remove_item(id)
    self.line_items.destroy(id)
    self.reload
  end

  def load_address
    if self.user.present?
      saved_order = self.user.orders.where("bill_address_id is not null").first
      self.ship_address = self.bill_address = saved_order.bill_address if saved_order.present?
      self.save
    end
  end
end
