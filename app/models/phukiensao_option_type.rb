class PhukiensaoOptionType < ActiveRecord::Base
  self.table_name = "spree_option_types"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :name, :presentation, :position

  establish_connection(:phukiensao_production)

  # create option type if not exist
  # create product option type when option
  def self.clone_db(product, clone_product)
    product.option_types.each do |type|
      clone_type = PhukiensaoOptionType.find_by_id(type.id)
      if clone_type.blank?
        clone_type = PhukiensaoOptionType.create(name: type.name, presentation: type.presentation, position: type.position)
      end
      product_option_type = Spree::ProductOptionType.where(product_id: product.id, option_type_id: type.id).first
      PhukiensaoProductOptionType.create(position: product_option_type.position, product_id: clone_product.id, option_type_id: clone_type.id) if product_option_type.present?
    end
  end
end
