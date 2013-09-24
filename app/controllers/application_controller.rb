class ApplicationController < ActionController::Base
  before_filter :get_notifications
  protect_from_forgery
  helper 'spree/analytics'

  def get_notifications
    if current_user
      @notifications = current_user.notifications.unread.order("created_at desc")
    end
  end
end
