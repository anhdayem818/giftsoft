Spree::OrdersController.class_eval do
  before_filter :check_authorization
  def populate
    puts "=================================="
    puts session[:order_id]
    @order = current_order(true)

    item = nil
    params[:products].each do |product_id,variant_id|
      quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
      item = @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      quantity = quantity.to_i
      item = @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:variants]

    fire_event('spree.cart.add')
    fire_event('spree.order.contents_changed')
    @out_stock = item.nil?
    respond_with(@order) { |format| 
      format.html { redirect_to cart_path } 
      format.text { render :partial => "spree/shared/cart_details", :formats => [:html]}
    }
    
    
  end
  
  def index
    @orders = spree_current_user.orders.includes([:user, :shipments, :payments]).page(params[:page]).per(Spree::Config[:orders_per_page])
    respond_with(@orders)
  end
  
  def destroy
    
  end
  private
    def check_authorization
      return if spree_current_user
      session[:access_token] ||= params[:token]
      order = Spree::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, session[:access_token]
      else
        authorize! :create, Spree::Order.new
      end
    end
end
