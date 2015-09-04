# encoding: UTF-8
Spree::Product.class_eval do
  acts_as_commentable
  attr_accessible :short_desc, :original_price, :is_clone, :public
  delegate_belongs_to :master, :original_price

  has_many :notifications, :as => :notificationable

  def in_process
    has_variants? ? variants.sum(&:in_process) : master.in_process
  end
  
  def sole_out(start_date = 7.days.ago, end_date = Time.now)
    has_variants? ? variants.sum{|v| v.sole_out(start_date, end_date)} : master.sole_out(start_date, end_date)
  end
  
  def self.not_deleted
    where('spree_products.deleted_at IS NULL')
  end

  def self.available
    where('spree_products.available_on IS NOT NULL')
  end
  
  def show_in_report?(start_date = 7.days.ago, end_date = Time.now)
    sole_out(start_date, end_date) != 0 || in_process != 0 || on_hand != 0
  end
  
  def resume
    self.update_column(:deleted_at, nil)
    variants_including_master_and_deleted.update_all(:deleted_at => nil)
  end

  def self.post_product_to_thi_truong_si
    product = Spree::Product.joins({taxons: :parent}).where("parents_spree_taxons.name='Đồng hồ' and `spree_products`.posted=false").group("`spree_products`.id").readonly(false).first
    if product.present?
      File.open("log/track_post_product.log", "a") do |file|
        file.puts "******************** Product id: #{product.id} ********************"
      end

      productunits = {
          "cai" => 1,
          "bo" => 5,
          "cap" => 2,
          "doi" => 4,
          "ri" => 3
      }

      categorylv2s = {
          "female_accessory" => 98,
          "male_accessory" => 97,
          "other_accessory" => 149
      }

      categorylv3s = {
          "female_watch" => 57,
          "male_watch" => 45
      }

      taxon_names = product.taxons.collect(&:name)
      File.open("log/track_post_product.log", "a") do |file|
        file.puts "Taxon names: #{taxon_names}"
      end

      productunit = taxon_names.include?("Đồng hồ đôi/cặp") ?  productunits["cap"] : productunits["cai"]

      if taxon_names.include?("Đồng hồ nam")
        File.open("log/track_post_product.log", "a") do |file|
          file.puts "==== Dong ho nam"
        end
        categorylv2 = categorylv2s["male_accessory"]
        categorylv3 = categorylv3s["male_watch"]
        product.startPost(productunit, categorylv2, categorylv3, "nam")
      elsif taxon_names.include?("Đồng hồ nữ")
        File.open("log/track_post_product.log", "a") do |file|
          file.puts "==== Dong ho nu"
        end
        categorylv2 = categorylv2s["female_accessory"]
        categorylv3 = categorylv3s["female_watch"]
        product.startPost(productunit, categorylv2, categorylv3, "nữ")
      
      end

      
      if taxon_names.exclude?("Đồng hồ nam") && taxon_names.exclude?("Đồng hồ nữ")
        File.open("log/track_post_product.log", "a") do |file|
          file.puts "==== Dong ho khac"
        end
        categorylv2 = categorylv2s["other_accessory"]
        product.startPost(productunit, categorylv2)
      end
    end
  end


  def startPost(productunit, categorylv2, categorylv3 = nil, gender = nil)
    images = []
    self.master.images.each do |image|
      images.push({"url" => "http://muamely.com#{image.attachment.url}", "alt" => image.alt})
    end

    self.variants.each do |variant|
      variant.images.each do |image|
        images.push({"url" => "http://muamely.com#{image.attachment.url}", "alt" => image.alt})
      end
    end

    if images.length > 0
      agent = Mechanize.new

      # Fill information to log in
      login_page = agent.get("https://thitruongsi.com/user/login/")
      login_form = login_page.form_with(:action => "https://thitruongsi.com/user/login?redirecturl=")
      login_form.email = "shopmuamely@gmail.com"
      login_form.password = "muamely123"
      login_button = login_form.button_with(:value => "Đăng nhập")

      # Log in
      logged_page = login_form.submit(login_button)
      user_panel = logged_page.search(".user")


      if user_panel.at("#addproductlink").present?
        product_name = "#{self.name} - #{self.sku}"
        product_name += " (#{gender})" if gender.present?
        desc = description.present? ? description.gsub("../../..", "http://muamely.com") : ""
        params = {
            "productname" => product_name,
            "price" => self.price,
            "productunit" => productunit,
            "categorylv1" => 3, # Phu kien
            "categorylv2" => categorylv2,
            "product_desc" => desc
        }

        params.merge!({"categorylv3" => categorylv3}) if categorylv3.present?

        image_index = 0
        can_post = false
        images.each do |image|
          content = open("https://thitruongsi.com/ajax/fetchImage?url=#{CGI.escape(image["url"])}").read
          response = JSON.parse content
          if response["code"] == 1
            can_post = true
            params.merge!({
                              "image[frompc][#{image_index}]" => 0,
                              "image[file][#{image_index}]" => response["file"],
                              "image[description][#{image_index}]" => "#{image["alt"].present? ? image["alt"] : ''}"
                          })
            if image_index == 0
              params.merge!({"feature_image" => response["file"]})
            end
            image_index += 1
          end
        end

        File.open("log/track_post_product.log", "a") do |file|
          file.puts "Can post: #{can_post}"
          file.puts params
        end

        if can_post
          page_after_add_product = agent.post('https://thitruongsi.com/shop/doaddproduct/', params)

          if page_after_add_product.at(".alert-success").present?
            self.posted = true
            self.save
            File.open("log/track_post_product.log", "a") do |file|
              file.puts "Post success"
              file.puts self.inspect
            end
          else
            File.open("log/track_post_product.log", "a") do |file|
              file.puts "Post fail"
              file.puts page_after_add_product.at(".alert-warning").inner_html if page_after_add_product.at(".alert-warning").present?
              file.puts self.inspect
            end
          end
        else
          File.open("log/track_post_product.log", "a") do |file|
            file.puts "Error upload image"
          end
        end
      end
    end
    self.posted = true
    self.save
  end
end