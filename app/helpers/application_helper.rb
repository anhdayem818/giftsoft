module ApplicationHelper
  def title
    
  end
  
  def min_total
    if(current_user.present? && current_user.has_spree_role?("sale"))
      return 0
    end
    if returning_customer? 
      if current_user.orders.select(&:paid?).sum(&:total) > 1000000
        100000 
      else
        200000
      end
    else
      500000
    end
  end
  def checkoutable?
    item_total = current_order.present? ? current_order.item_total : 0
    item_total >= min_total
  end
  
  def returning_customer?
    current_user.present? && current_user.orders.select(&:paid?).present?
  end
end
