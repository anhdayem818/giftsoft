module Spree
  module Admin
    UsersController.class_eval do
      before_filter :load_report_data, :only => :index
      def load_report_data
        @points_total = User.sum(:point)
      end

    end
  end
end
