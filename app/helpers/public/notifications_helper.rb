module Public::NotificationsHelper

  def like_unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false, action: "like")
  end

  def follow_unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false, action: "follow")
  end

  def comment_unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false, action: "comment")
  end

end
