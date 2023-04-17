class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    # フォロー通知を作成し、フォローされたユーザーへ
    @user.create_notification_follow!(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.where(is_deleted: false)
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.where(is_deleted: false)
  end
end
