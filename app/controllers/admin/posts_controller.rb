class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = case
    when params[:user_id]
      Post.where(user_id: params[:user_id]).order(created_at: :desc)
    when params[:word]
      Post.search_for(params[:word])
    else
      Post.all.order(created_at: :desc)
    end
    @posts = @posts.page(params[:page]).per(20)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer, notice: "投稿を削除しました"
  end

end
