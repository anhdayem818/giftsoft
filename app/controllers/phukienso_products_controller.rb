class PhukiensoProductsController < Spree::BaseController
  before_filter :authenticate_admin

  def clone
    product = Spree::Product.find_by_id(params[:id])
    if PhukiensaoProduct.clone_db(product)
      render :json => {result: 'success'}
    else
      render :json => {result: 'fail'}
    end
  end

  private
  def authenticate_admin
    redirect_to '/' and return if spree_current_user.blank? || !spree_current_user.admin_group?
  end
end
