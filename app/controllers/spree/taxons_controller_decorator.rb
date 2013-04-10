Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    if (current_user.present? && current_user.admin_group?)
      @products = @searcher.retrieve_products.order("spree_products.name")
    else
      @products = @searcher.retrieve_products.order("spree_products.updated_at DESC")
    end


    respond_with(@taxon)
  end
end
