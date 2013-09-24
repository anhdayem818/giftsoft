module NotificationsHelper

  def html_notify(notify)
    html = "<div class=\"user-comment\"><span class=\"username\">" + notify.user.username +
            "</span> " + (t "create_comment").downcase +  " SP</div><div class=\"notificationable-name\">" + notify.notificationable.name + "</div>"
    html.html_safe
  end
end