class PhukiensaoProduct < ActiveRecord::Base
  self.table_name = "spree_products"
  self.primary_key = "id"
  attr_protected :id
  establish_connection(:phukiensao_production)
  def self.clone_db(product)
    PhukiensaoTaxonomy.clone_exactly()
    PhukiensaoTaxon.clone_exactly()


    if product.present?
      params = product.attributes
      params.delete("is_clone")
      clone_product = self.new(params)
      clone_product.id = nil

      puts "clone product: #{clone_product.to_json}"

      if clone_product.save
        # create option type
        PhukiensaoOptionType.clone_db(product, clone_product)
        # create product taxon
        PhukiensaoProductTaxon.clone_db(product, clone_product)

        # set prepare to update url img
        desc = product.description
        puts "clone product save success"

        product.variants_including_master_and_deleted.each do |v|
          puts "variant of product: #{v.to_json} ---------------------------------"
          params = v.attributes
          params.delete("product_id")
          params.delete("id")
          clone_variant = PhukiensaoVariant.new(params)
          clone_variant.product_id = clone_product.id

          # optional , increase price
          if clone_variant.price > 50000
            clone_variant.price = clone_variant.price + 50000
          else
            clone_variant.price = clone_variant.price * 2
          end


          puts "clone variant: #{clone_variant.to_json}"
          if clone_variant.save
            # clone option value
            PhukiensaoOptionValue.clone_db(v, clone_variant)

            puts "clone variant success"
            v.images.each do |img|
              puts "image of variant: #{img.to_json} -------------------------------"
              clone_image = PhukiensaoProductImage.clone_db(img, clone_variant.id)

              desc = desc.gsub("spree/products/#{img.id}", "spree/products/#{clone_image.id}") if desc.include?("spree/products/#{img.id}")

            end
          end
        end

        # add new image if not exist in variant
        nokogiri_desc = Nokogiri::HTML(desc)
        nokogiri_desc.search('img').each do |img_tag|
          #puts "tagggggggggggggggggggggggggggggggggggggggggggggggggg"
          #puts img_tag.attr('src')
          #puts img_tag.attr('src').include?("spree/products/")
          #puts !img_tag.attr('src').include?("http")
          if img_tag.attr('src').include?("spree/products/") && !img_tag.attr('src').include?("http")
            img_id = img_tag.attr('src').split('/products/')[1].split('/')[0]
            #puts "image iddddddddddddddddddd #{img_id}"
            #img_id = img_tag.attr('src').gsub("../../../spree/products/", "").split("/")[0]
            pks_img = PhukiensaoProductImage.find_by_id(img_id)
            if pks_img.blank? || (pks_img.present? && pks_img.viewable.present? && pks_img.viewable.product.present? && pks_img.viewable.product.id != clone_product.id)
              clone_image = PhukiensaoProductImage.clone_db(Spree::Image.find_by_id(img_id), nil) if Spree::Image.find_by_id(img_id).present?
              desc = desc.gsub("spree/products/#{img_id}", "spree/products/#{clone_image.id}")
            end
          end
        end

        #if desc != product description => update
        if desc != clone_product.description
          clone_product.update_attributes(description: desc)
          #puts 'update descrption ===========================*****************%%%%%%%%%%%%%%%%%%'
        end

        puts 'update is_clone========================================'
        product.update_attributes(is_clone: true)
      else
        puts "((((((((((((((((((((((((+++++++++++++++++++++++++++++++"
        puts clone_product.errors.to_yaml
        false
      end
    else
      false
    end
  end


end
