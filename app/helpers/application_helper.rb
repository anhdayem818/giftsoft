module ApplicationHelper
  def title
    
  end
  
  def min_total
    if(current_user.present? && current_user.has_spree_role?("sale"))
      return 0
    end
    if returning_customer? 
      if current_user.orders.select(&:paid?).sum(&:total) > 500000
        0 
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

  def clone_product_btn(product)
    if product.is_clone
      "<a class='clone btn btn-mini disabled' disabled>Cloned</a>"
    else
      "<a class='clone active btn btn-mini btn-primary' data-id='#{product.id}'>Clone</a>"
    end

  end
end
