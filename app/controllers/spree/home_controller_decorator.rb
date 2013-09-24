Spree::HomeController.class_eval do
  before_filter :set_current_page

  def index
    @searcher = Spree::Config.searcher_class.new(params)
    if (current_user.present? && current_user.admin_group?)
      @products = @searcher.retrieve_products.order("name")
    else
      @products = @searcher.retrieve_products.order("updated_at DESC")
    end
    @promotion_products = @products.where("original_price IS NOT NULL")

    @announcements = Announcement.not_notices.limit(5).order("created_at DESC")
    @notices = Announcement.notices
    @last_notice_time = Announcement.notices.maximum(:updated_at)
    @comments = Comment.limit(5).order("created_at DESC")

    respond_with(@products) do |format|
      format.html
      format.js
    end
  end

  def set_current_page
    @current_page = "home"
  end
end
