module NotificationsHelper

  def html_notify(notify)
    user_comment = notify.user_comment.present? ? notify.user_comment.username : (t "customer")
    html = "<div class=\"user-comment\"><span class=\"username\">" + user_comment +
            "</span> " + (t "create_comment").downcase +  " SP</div><div class=\"notificationable-name\">" + notify.notificationable.name + "</div>"
    html.html_safe
  end
end