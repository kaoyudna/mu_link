class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = case
    when params[:user_id]
      # 受け取ったユーザーIDの投稿を取得
      Post.where(user_id: params[:user_id])
    when params[:word]
      # 入力された文字に部分一致する投稿を取得
      Post.search_for(params[:word])
    else
      Post.all
    end
    @posts = @posts.page(params[:page]).per(20)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer, notice: "投稿を削除しました"
  end

end
