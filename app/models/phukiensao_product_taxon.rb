class PhukiensaoProductTaxon < ActiveRecord::Base
  self.table_name = "spree_products_taxons"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :product_id, :taxon_id

  establish_connection(:phukiensao_production)

  def self.clone_db(product, clone_product)
    product.taxons.each do |taxon|
      PhukiensaoProductTaxon.create(product_id: clone_product.id, taxon_id: taxon.id)
    end
  end
end
