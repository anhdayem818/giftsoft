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
      respond_with(@products) do |format|
        format.html
        format.json { render :json => json_data }
      end
    end

    def json_data
      json_format = params[:json_format] or 'default'
      case json_format
      when 'basic'
        @products.map {|p| {'id' => p.id, 'name' => p.name}}.to_json
      else
        @products.limit(10).to_json(:include => {:variants => {:include => {:option_values => {:include => :option_type},
                                                      :images => {:only => [:id], :methods => :mini_url}}},
                                                      :images => {:only => [:id], :methods => :mini_url}, :master => {}})
      end
    end
  end
end
