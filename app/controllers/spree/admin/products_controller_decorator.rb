module Spree
  module Admin
    ProductsController.class_eval do
      def update
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
        end
        if params[:product][:weight].present?
          if @product.has_variants?
            @product.variants_including_master.update_all("weight" => params[:product][:weight])
          end
        end
        super
      end
      def resume
        @product = find_resource
        @product.resume
        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js  { render 'actions' }
        end
      end

      protected

      def collection
        return @collection if @collection.present?

        unless request.xhr?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"

          params[:q][:s] ||= "name asc"

          @search = super.ransack(params[:q])
          @collection = @search.result.
              group_by_products_id.
              includes([:master, {:variants => [:images, :option_values]}]).
              page(params[:page]).
              per(Spree::Config[:admin_products_per_page])

          # PostgreSQL compatibility
          if params[:q][:s].include?("master_price")
            @collection = @collection.group("spree_variants.price")
          end
        else
          includes = [{:variants => [:images,  {:option_values => :option_type}]}, {:master => :images}]

          @collection = super.where(["name #{LIKE} ? AND deleted_at is null", "%#{params[:q]}%"])
          @collection = @collection.includes(includes).limit(params[:limit] || 10)

          tmp = super.where(["#{Variant.table_name}.sku #{LIKE} ?", "%#{params[:q]}%"])
          tmp = tmp.includes(:variants_including_master).limit(params[:limit] || 10)
          @collection.concat(tmp).uniq!
        end
        @collection
      end
    end
  end
end
