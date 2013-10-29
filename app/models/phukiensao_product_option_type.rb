class PhukiensaoProductOptionType < ActiveRecord::Base
  self.table_name = "spree_product_option_types"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :position, :product_id, :option_type_id

  establish_connection(:phukiensao_production)
end
