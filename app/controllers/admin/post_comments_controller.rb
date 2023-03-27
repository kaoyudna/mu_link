class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inappropriate_comments = InappropriateComment.all
    @inappropriate_comment = InappropriateComment.new
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
        #上記の処理が完了した後に変数内の重複したidを除外
        @post_comments.uniq!(&:id)
    elsif params[:word]
      @post_comments = PostComment.search_for(params[:word])
    else
      @post_comments = PostComment.all.order(is_deleted: :asc).order(created_at: :desc)
    end
    @post_comments = @post_comments.page(params[:page]).per(20)
  end

  def update
    post_comment = PostComment.find(params[:id])
    post_comment.update(is_deleted: true)
    redirect_to admin_post_comments_path, notice: "コメントを削除しました"
  end

end
