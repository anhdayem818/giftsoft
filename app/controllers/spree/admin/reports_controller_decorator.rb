module Spree
  module Admin
    ReportsController.class_eval do
      respond_to :html

      AVAILABLE_REPORTS = {
        :sales_total => { :name => I18n.t(:sales_total), :description => I18n.t(:sales_total_description) },
        :sales_detail => { :name => I18n.t(:sales_total), :description => I18n.t(:sales_total_description) }
      }

      def index
        @reports = AVAILABLE_REPORTS
        respond_with(@reports)
      end

      def sales_total
        params[:q] = {} unless params[:q]

        if params[:q][:paid_at_gt].blank?
          params[:q][:paid_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:paid_at_gt] = Time.zone.parse(params[:q][:paid_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:created_at_lt].blank?
          params[:q][:paid_at_lt] = Time.zone.parse(params[:q][:paid_at_lt]).end_of_day rescue ""
        end

        params[:q][:payment_state_eq] = "paid"

        @search = Order.complete.ransack(params[:q])
        @orders = @search.result
        @item_total = @orders.sum(:item_total)
        @adjustment_total = @orders.sum(:adjustment_total)
        @sales_total = @orders.sum(:total)

        @reports = Order.get_report(params[:q][:paid_at_gt], params[:q][:paid_at_lt].blank? ? Time.zone.now : params[:q][:paid_at_lt])

        respond_with
      end

      def sales_detail
        params[:q] = {} unless params[:q]
        params[:q][:s] ||= "name"
        if params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.now.beginning_of_week
        else
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.now.beginning_of_week
        end
        if params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.now
        else
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue Time.now
        end
        
        #params[:q][:payment_state_eq] = "paid"
        @start_date = params[:q][:created_at_gt]
        @end_date = params[:q][:created_at_lt]
        @search = Product.not_deleted.ransack({:s => "name"})
        @products = @search.result
        #@products = Product.not_deleted.order(:name)
      end
    end
  end
end
