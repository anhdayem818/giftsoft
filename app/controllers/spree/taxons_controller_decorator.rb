Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    if (current_user.present?)
      if(current_user.admin_group?)
        @products = @searcher.retrieve_products.order("spree_products.name")
      elsif current_user.vip # only show hidden products to vip customers
        @products = @searcher.retrieve_products.order("spree_products.updated_at DESC")
      else
        @products = @searcher.retrieve_products.where(:public => true).order("spree_products.updated_at DESC")
      end
      
    else
      @products = @searcher.retrieve_products.where(:public => true).order("spree_products.updated_at DESC")
    end


    respond_with(@taxon) do |format|
      format.html
      format.js
    end
  end
end
