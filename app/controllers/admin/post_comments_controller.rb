class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post_comments = PostComment.all.order(created_at: :desc)
    if params[:post_id]
      @post_comments = PostComment.where(post_id: params[:post_id])
    end
  end

  def destroy
    post_comment = PostComment.find(params[:id])
    post_comment.destroy
    redirect_to request.referer, notice: "コメントを削除しました"
  end
end
