class PhukiensaoTaxonomy < ActiveRecord::Base
  self.table_name = "spree_taxonomies"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :name, :position, :created_at, :updated_at

  establish_connection(:phukiensao_production)
  def self.clone_exactly()
    Spree::Taxonomy.all.each do |taxonomy|
      if PhukiensaoTaxonomy.find_by_id(taxonomy.id).blank?
        PhukiensaoTaxonomy.create(taxonomy.attributes)
      end
    end
  end
end
