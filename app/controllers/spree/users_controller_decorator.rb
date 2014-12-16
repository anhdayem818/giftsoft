Spree::UsersController.class_eval do
  def show
    @orders = @user.orders.complete
    @share_files = Spree::ShareFile.all
  end

  def download_shared_file
    if spree_current_user.present? && spree_current_user.vip
      @share_file = Spree::ShareFile.find(params[:share_file_id])
      data = File.read(@share_file.attachment.file.path)
      send_data data, :x_sendfile => true, :disposition => 'attachment', filename: @share_file.attachment.file.filename, type: @share_file.attachment.file.content_type
    end
  end
end