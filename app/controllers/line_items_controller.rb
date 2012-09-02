class LineItemsController < Spree::BaseController
  def destroy
    Spree::LineItem.delete(params[:id])
    respond_to do |format|
      format.text { render :partial => "spree/shared/cart_details", :formats => [:html]}
    end
  end
end
