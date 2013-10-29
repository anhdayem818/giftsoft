class PhukiensaoVariant < ActiveRecord::Base
  self.table_name = "spree_variants"
  self.primary_key = "id"
  attr_protected :id

  #has_and_belongs_to_many :option_values, :class_name => PhukiensaoOptionValue, join_table: :spree_option_values_variants

  establish_connection(:phukiensao_production)

end
