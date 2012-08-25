class CommentsController < ActionController::Base
  def create
    @product = Spree::Product.find(params[:product_id])
    #params[:comment][:user_id] = current_user.id if current_user.present?
    comment = @product.comments.build(params[:comment])
    comment.user = current_user
    comment.save
    redirect_to :back
  end
end