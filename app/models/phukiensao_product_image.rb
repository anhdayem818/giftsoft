class PhukiensaoProduct < ActiveRecord::Base
  self.table_name = "spree_products"
  self.primary_key = "id"
  attr_protected :id

  def self.clone(product)
    if product.present?

      establish_connection(:phukiensao_production)
      params = product.attributes
      params.delete("is_clone")
      clone_product = self.new(params)
      clone_product.id = nil
      if clone_product.save
        params = product.images.first.attributes
        clone_image = clone_product.images.build(params)
        clone_image.id = nil
        clone_image.product_id = clone_product.id
        clone.save

        product.is_clone = true
        product.save
      else
        false
      end
    else
      false
    end
  end
end
