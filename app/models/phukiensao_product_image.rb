class PhukiensaoProductImage < ActiveRecord::Base
  self.table_name = "spree_assets"
  self.primary_key = "id"
  attr_protected :id
  attr_accessible :id, :type, :viewable_id, :attachment_width, :attachment_height, :attachment_file_size, :position, :viewable_type, :attachment_content_type, :attachment_file_name, :attachment_updated_at, :alt
  has_attached_file :attachment,
                    styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                    default_style: :product,
                    url: '/spree/products/:id/:style/:basename.:extension',
                    path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                    convert_options: { all: '-strip -auto-orient' }
  establish_connection(:phukiensao_production)
end
