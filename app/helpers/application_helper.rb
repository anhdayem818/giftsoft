module ApplicationHelper
  def title
    
  end
  
  def min_total
    returning_customer? ? 200000 : 500000
  end
  def checkoutable?
    item_total = current_order.present? ? current_order.item_total : 0
    item_total >= min_total
  end
  
  def returning_customer?
    current_user.present? && current_user.orders.select(&:paid?).present?
  end
end
