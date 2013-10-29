class PhukiensaoOptionValue < ActiveRecord::Base
  self.table_name = "spree_option_values"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :position, :name, :presentation, :option_type_id

  establish_connection(:phukiensao_production)

  def self.clone_db(variant, clone_variant)
    variant.option_values.each do |value|
      clone_option_value = PhukiensaoOptionValue.find_by_id(value.id)
      if clone_option_value.blank?
        clone_option_value = PhukiensaoOptionValue.create(position: value.position, name: value.name, presentation: value.presentation, option_type_id: value.option_type_id)
      end
      PhukiensaoOptionValueVariant.create(variant_id: clone_variant.id, option_value_id: clone_option_value.id)
      #clone_variant.option_values << clone_option_value #if option_value_variant.present?
    end
  end
end
