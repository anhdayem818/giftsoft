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

  def self.clone_db(img, variant_id)
    params = img.attributes
    max_id = PhukiensaoProductImage.maximum(:id) || 0
    clone_image_id = max_id + 1
    params.delete(:id)
    clone_image = PhukiensaoProductImage.new(params)
    clone_image.id = clone_image_id
    clone_image.viewable_id = variant_id if variant_id.present?
    clone_image.attachment = URI.parse("http://phukiensao.com/spree/products/#{clone_image_id}/#{URI.encode(params['attachment_file_name'])}")
    clone_image.attachment_file_name = params['attachment_file_name']
    clone_image.attachment_content_type = params["attachment_content_type"]
    puts "clone image"
    clone_image.save

    FileUtils.mkdir("/home/wf04/Desktop/research-project/giftshop_clone/public/spree/products/#{clone_image.id}")
    FileUtils.cp_r(Dir.glob("/home/wf04/Desktop/research-project/giftshop/public/spree/products/#{img.id}/*"), "/home/wf04/Desktop/research-project/giftshop_clone/public/spree/products/#{clone_image.id}/")

    #system "mkdir /home/rails/phukiensao.com/public/spree/products/#{clone_image.id} && cp -r /home/rails/muamely.com/public/spree/products/#{img.id}/* /home/rails/phukiensao.com/public/spree/products/#{clone_image.id}"
    #system "mkdir /home/rails/phukiensao.com/public/spree/products/#{clone_image.id}"
    #system "cp -r /home/rails/muamely.com/public/spree/products/#{img.id}/* /home/rails/phukiensao.com/public/spree/products/#{clone_image.id}"

    #FileUtils.mkdir("/home/rails/phukiensao.com/public/spree/products/#{clone_image.id}")
    #FileUtils.cp_r(Dir.glob("/home/rails/muamely.com/public/spree/products/#{img.id}/*"), "/home/rails/phukiensao.com/public/spree/products/#{clone_image.id}")

    return clone_image
  end
end
