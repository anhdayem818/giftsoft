Spree::CheckoutController.class_eval do
  include ApplicationHelper
  before_filter :validate_order_total, :only => [:edit]
  before_filter :load_order_address, :only => [:edit]
  def validate_order_total
    redirect_to cart_path, :notice => t(:order_total_not_enough_message) if @order.item_total < min_total
    #redirect_to cart_path, :notice => t(:some_items_out_of_stock) unless @order.validate_items
  end
  def load_order_address
    @order.load_address
  end
  private
    def check_authorization
      return if spree_current_user
      authorize!(:edit, current_order, session[:access_token])
    end

end
