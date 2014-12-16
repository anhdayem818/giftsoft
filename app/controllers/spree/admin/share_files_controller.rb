module Spree
  module Admin
    class ShareFilesController < ResourceController

      def index
        page = params[:page] || 1
        @share_files = Spree::ShareFile.page(page).per(Spree::Config[:admin_products_per_page])
      end

      def new
        @share_file = Spree::ShareFile.new
      end

      def create
        @share_file = Spree::ShareFile.create(params[:share_file])
        redirect_to spree.admin_share_files_path
      end

      def edit
        get_share_file
      end

      private

      def get_share_file
        @share_file = Spree::ShareFile.find(params[:id])
      end
    end
  end
end