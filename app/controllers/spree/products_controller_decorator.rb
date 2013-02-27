Spree::ProductsController.class_eval do
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
  
end
