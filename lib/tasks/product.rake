namespace :product do
  task :merge_variants => :environment do 
    hong = Spree::OptionValue.find_by_name('hong')
    # Go through all undeleted products
    Spree::Product.where('deleted_at is null').each do |product|
      if Spree::Product.where("id = ?", product.id).present?
        # If product only have 1 variant
        if product.variants.count == 0 && product.master.present?
          variants = Spree::Variant.where(:sku => product.master.sku).where("deleted_at is null").all
          if variants.count > 1
            puts product.id
            # Create a new copy and make it master
            mp = product.duplicate
            mp.master.sku = product.master.sku
            #_index = product.name.rindex('_')
            name = product.name
            mp.name=name
            mp.master.is_master = true
            mp.master.images = []
            mp.master.images << product.master.images[0].dup if product.master.images.present?
            mp.master.save
            mp.save
            variants.each do |variant|
              _index = variant.product.name.rindex('_')
              name = _index.nil? ? variant.product.name : variant.product.name.slice(0, _index)
              option = if _index.present?
                option_pres = variant.product.name.slice(_index+1, variant.product.name.length - name.length)
                Spree::OptionValue.find_by_presentation(option_pres)
              end
              option ||= hong
            
              p = variant.product
              variant.product = mp
              variant.is_master = false
              variant.set_option_value('color', option.name)
              Spree::Product.where("id=?", p.id).delete_all
            end
            
          end
        end
      end
    end
  end
end