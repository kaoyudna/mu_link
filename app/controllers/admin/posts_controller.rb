class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.order(created_at: :desc)
    if params[:user_id]
      @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)
    elsif params[:word]
      @posts = Post.search_for(params[:word])
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer, notice: "投稿を削除しました"
  end
end
