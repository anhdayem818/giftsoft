Spree::Admin::ImagesController.class_eval do

  def create
    authorize! :create, Spree::Image
    image_count = params[:images].length
    for i in 0..(image_count - 1) do
      params[:image] = {}
      params[:image][:attachment] = params[:files][i]
      params[:image][:viewable_id] = params[:images]["#{i}"][:viewable_id]
      params[:image][:viewable_type] = 'Spree::Variant'
      params[:image][:alt] = params[:images]["#{i}"][:alt]
      @image = Spree::Image.create(params[:image])
    end
    redirect_to admin_product_images_url(@product)
  end

  def load_data
    @product = Spree::Product.where(:permalink => params[:product_id]).first
    @variants = @product.variants.collect do |variant|
      [variant.options_text, variant.id]
    end
    @variants.insert(0, [I18n.t(:all), @product.master.id])
  end
end