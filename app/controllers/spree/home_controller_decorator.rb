Spree::HomeController.class_eval do
  before_filter :set_current_page
#  def index
#    @latest_products = Spree::Product.limit(6).order(:created_at)
#    @feature_products = Spree::Product.limit(6)
#    respond_with(@latest_products)
#  end
  def set_current_page
    @current_page = "home"
  end
end
