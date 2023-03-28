class Public::NotificationsController < ApplicationController

  def update
    @notification = Notification.find(params[:id])
    @notification.update(checked: true)
  end

end
