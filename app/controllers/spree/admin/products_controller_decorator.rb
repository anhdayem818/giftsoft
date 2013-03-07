module Spree
  module Admin
    ProductsController.class_eval do
      
        def update_before
          # note: we only reset the product properties if we're receiving a post from the form on that tab
          #@product = @object
          if params[:product].present?
            @taxon = Taxon.find(params[:taxon_id])
            if @taxon
              @product.taxons.destroy_all
              @product.taxons << @taxon
              @product.save
              @taxons = @product.taxons
            end
          end
          return unless params[:clear_product_properties]
          params[:product] ||= {}
        end
    end
  end
end
