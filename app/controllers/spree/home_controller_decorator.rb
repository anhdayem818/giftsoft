Spree::HomeController.class_eval do
  before_filter :set_current_page
  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products.order("updated_at DESC")
    respond_with(@products)
  end
  def set_current_page
    @current_page = "home"
  end
end
