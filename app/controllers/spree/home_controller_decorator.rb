Spree::HomeController.class_eval do
  before_filter :set_current_page
  def index
    @searcher = Spree::Config.searcher_class.new(params)
    if (current_user.present? && current_user.admin_group?)
      @products = @searcher.retrieve_products.order("name")
    else
      @products = @searcher.retrieve_products.order("updated_at DESC")
    end
    
    @announcements = Announcement.not_notices.limit(5).order("created_at DESC")
    @notices = Announcement.notices
    @last_notice_time = Announcement.notices.maximum(:updated_at)
    @comments = Comment.limit(5).order("created_at DESC")
    respond_with(@products)
  end
  def set_current_page
    @current_page = "home"
  end
end
