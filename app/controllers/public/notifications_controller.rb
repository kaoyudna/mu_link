class Public::NotificationsController < ApplicationController

  def update
    @notification = Notification.find(params[:id])
    # checked: ture = 
    @notification.update(checked: true)
  end

end
