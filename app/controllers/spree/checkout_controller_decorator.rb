Spree::CheckoutController.class_eval do
  
  private
    def check_authorization
      return if spree_current_user
      authorize!(:edit, current_order, session[:access_token])
    end

end
