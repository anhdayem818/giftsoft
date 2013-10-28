class PhukiensaoProduct < ActiveRecord::Base
  self.table_name = "spree_products"
  self.primary_key = "id"
  attr_protected :id
  establish_connection(:phukiensao_production)
  def self.clone(product)
    if product.present?
      params = product.attributes
      params.delete("is_clone")
      clone_product = self.new(params)
      clone_product.id = nil
      puts "clone product: #{clone_product.to_json}"

      if clone_product.save
        # set prepare to update url img
        desc = product.description
        puts "clone product save success"
        product.variants_including_master.each do |v|
          puts "variant of product: #{v.to_json} ---------------------------------"
          params = v.attributes
          params.delete("product_id")
          params.delete("id")
          clone_variant = PhukiensaoVariant.new(params)
          clone_variant.product_id = clone_product.id
          puts "clone variant: #{clone_variant.to_json}"
          if clone_variant.save
            puts "clone variant success"
            v.images.each do |img|
              puts "image of variant: #{img.to_json} -------------------------------"
              params = img.attributes
              max_id = PhukiensaoProductImage.maximum(:id) || 0
              clone_image_id = max_id + 1
              params.delete(:id)
              clone_image = PhukiensaoProductImage.new(params)
              clone_image.id = clone_image_id
              clone_image.viewable_id = clone_variant.id
              clone_image.attachment = URI.parse("http://muamely.com/spree/products/#{clone_image_id}/#{params['attachment_file_name']}")
              clone_image.attachment_file_name = params['attachment_file_name']
              clone_image.attachment_content_type = params["attachment_content_type"]
              puts "clone image"
              clone_image.save
              #system "mkdir /home/wf04/Desktop/research-project/a_gift_shop/#{clone_image_id}"
              #system "cp -r /home/wf04/Desktop/research-project/giftshop/public/spree/products/#{img.id}/* /home/wf04/Desktop/research-project/a_gift_shop/#{clone_image_id}"
              system "mkdir /home/rails/phukiensao.com/public/spree/products/#{clone_image_id}"
              system "cp -r /home/rails/muamely.com/public/spree/products/#{img.id}/* /home/rails/phukiensao.com/public/spree/products/#{clone_image_id}"

              # update url img in description
              desc.gsub("spree/products/#{img.id}", "spree/products/#{clone_image_id}") if desc.include?("spree/products/#{img.id}")

            end
          end
        end

        #if desc != product description => update
        if desc != clone_product.description
          clone_product.update_attributes(description: desc)
          puts 'update descrption ===========================*****************%%%%%%%%%%%%%%%%%%'
        end


        puts 'update is_clone========================================'
        product.is_clone = true
        product.save
      else
        puts "((((((((((((((((((((((((+++++++++++++++++++++++++++++++"
        puts clone_product.errors.to_yaml
        false
      end
    else
      false
    end
  end

  # disabled some method when clone product
  def set_master_variant_defaults
  end
  def add_properties_and_option_types_from_prototype
  end
  def build_variants_from_option_values_hash
  end
  def save_master
  end


end
