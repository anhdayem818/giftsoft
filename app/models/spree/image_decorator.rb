Spree::Image.class_eval do
  attachment_definitions[:attachment][:styles] = {
    :mini => '48x48>', # thumbs under image
    :small => '-resize x120 -gravity Center -crop 140x120+0+0 +repage', # images on category view
    :product => '320x240>', # full product image
    :large => '600x600>' # light box image
  }
end