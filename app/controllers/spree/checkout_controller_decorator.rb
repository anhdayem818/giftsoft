Spree::CheckoutController.class_eval do
  before_filter :validate_order_total, :only => [:edit]
  before_filter :load_order_address, :only => [:edit]
  def validate_order_total
    redirect_to cart_path, :notice => t(:order_total_not_enough_message) unless @order.validate_total
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
