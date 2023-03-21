class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.update(checked: true)
  end

  def mark_as_checked
    @notification = Notification.find(params[:id])
    @notification.update(checked: true)
    head :ok
  end
end
