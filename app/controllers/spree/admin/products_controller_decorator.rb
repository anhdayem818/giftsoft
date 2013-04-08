module Spree
  module Admin
    ProductsController.class_eval do
      def resume
        @product = find_resource
        @product.resume
        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js  { render 'actions' }
        end
      end
    end
  end
end
