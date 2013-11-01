class CommentsController < Spree::BaseController
  before_filter :authenticate_admin
  def create
    @product = Spree::Product.active.find_by_permalink!(params[:product_id])
    #params[:comment][:user_id] = current_user.id if current_user.present?
    comment = @product.comments.build(params[:comment])
    comment.user = current_user
    comment.save
    redirect_to :back
  end

  private
  def authenticate_admin
    redirect_to '/' and return if current_user.nil?
  end
end