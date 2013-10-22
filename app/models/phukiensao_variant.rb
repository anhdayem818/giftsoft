class PhukiensaoVariant < ActiveRecord::Base
  self.table_name = "spree_variants"
  self.primary_key = "id"
  attr_protected :id
  establish_connection(:phukiensao_production)
end
