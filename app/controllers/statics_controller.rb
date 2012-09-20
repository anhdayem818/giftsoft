class StaticsController < Spree::BaseController
  before_filter :set_current_page
  def show
    render params[:id]
  end
  def set_current_page
    @current_page = params[:id]
  end
end
