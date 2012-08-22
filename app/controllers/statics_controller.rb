class StaticsController < Spree::BaseController
  def show
    render params[:id]
  end
end
