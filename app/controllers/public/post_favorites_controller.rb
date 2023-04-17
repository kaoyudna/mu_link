class Public::PostFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.post_favorites.new(post_id: @post.id)
    favorite.save
    # いいね通知を作成し、投稿者へ送信
    @post.create_notification_like!(current_user)
    # 以下、Ajax用の記述
    @users = @post.favorite_users.where(is_deleted: false)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.post_favorites.find_by(post_id: @post)
    favorite.destroy
    # 以下、Ajax用の記述
    @users = @post.favorite_users.where(is_deleted: false)
  end
end
