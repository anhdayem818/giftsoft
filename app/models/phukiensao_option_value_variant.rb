class PhukiensaoOptionValueVariant < ActiveRecord::Base
  self.table_name = "spree_option_values_variants"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :variant_id, :option_value_id

  establish_connection(:phukiensao_production)

end
