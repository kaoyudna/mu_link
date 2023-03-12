class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post_comments = PostComment.all.order(created_at: :desc)
    @inappropriate_comments = InappropriateComment.all
    if params[:post_id]
      @post_comments = PostComment.where(post_id: params[:post_id])
    elsif params[:comment_id]
        #検索結果を入れる配列を@post_commentsとして用意
        @post_comments = []
        #不適切なコメントを配列から取り出す
        InappropriateComment.pluck(:comment).each do |comment|
        post_comments = PostComment.where('comment LIKE?',"%#{comment}%").order(created_at: :desc)
        #結果を@post_commentsの配列へ追加していく
        @post_comments.concat(post_comments)
      end

    end
  end

  def destroy
    post_comment = PostComment.find(params[:id])
    post_comment.destroy
    redirect_to request.referer, notice: "コメントを削除しました"
  end
end
