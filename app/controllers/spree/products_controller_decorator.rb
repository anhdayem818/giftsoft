module Spree
  ProductsController.class_eval do
    HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/
    def show
      return unless @product

      @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
      @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

      referer = request.env['HTTP_REFERER']


        @product.taxons.each do |taxon|
          @searcher = Spree::Config.searcher_class.new(:taxon => taxon.id)
        end
        @related_products = @searcher.retrieve_products


      respond_with(@product)
    end

    def index
#      if params[:show_out_stock] == '1'
#        Spree::Config[:show_zero_stock_products] = true
#      else
#        Spree::Config[:show_zero_stock_products] = nil
#      end
#      @searcher = Config.searcher_class.new(params)
#      @products = @searcher.retrieve_products
#      respond_with(@products)
      @products = Product.where(["spree_products.name #{LIKE} ?", "%#{params[:keywords]}%"])
        .where("deleted_at is null")
    end
  end
end
