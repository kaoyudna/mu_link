class Public::RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    @user.create_notification_follow!(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end
end
