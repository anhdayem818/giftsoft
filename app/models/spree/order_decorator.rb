Spree::Order.class_eval do
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
end
