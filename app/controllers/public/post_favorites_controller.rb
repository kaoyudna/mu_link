class Public::PostFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.post_favorites.new(post_id: @post.id)
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.post_favorites.find_by(post_id: @post)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
