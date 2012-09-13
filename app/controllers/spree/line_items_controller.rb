module Spree
  class LineItemsController < Spree::BaseController
    def destroy
      current_order.remove_item(params[:id])
      respond_to do |format|
        format.text { render :partial => "spree/shared/cart_details", :formats => [:html]}
      end
    end
  end
end
