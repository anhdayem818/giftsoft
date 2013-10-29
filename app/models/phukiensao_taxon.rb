class PhukiensaoTaxon < ActiveRecord::Base
  self.table_name = "spree_taxons"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :parent_id, :position, :name, :permalink, :taxonomy_id, :lft, :rgt, :icon_file_name, :icon_content_type,
                  :icon_file_size, :icon_updated_at, :description, :created_at, :updated_at

  establish_connection(:phukiensao_production)

  def self.clone_exactly()
    Spree::Taxon.all.each do |taxon|
      if PhukiensaoTaxon.find_by_id(taxon.id).blank?
        PhukiensaoTaxon.create(taxon.attributes)
      end
    end
  end
end
