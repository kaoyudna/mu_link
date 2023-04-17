class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inappropriate_comments = InappropriateComment.all
    @inappropriate_comment = InappropriateComment.new
    @post_comments = case params[:type]
    when params[:post_id]
      # 受け取った投稿IDに紐づくコメントを取得
      PostComment.where(post_id: params[:post_id])
    when params[:comment_id]
      # 不適切なワードに該当するコメントを取得
        post_comments = PostComment.with_inappropriate_comments
        Kaminari.paginate_array(post_comments)
    when params[:word]
      # 入力された文字に部分一致するコメントを取得
      PostComment.search_for(params[:word])
    else
      # 全ての投稿を取得(未削除のコメントを先頭に並び替え)
      PostComment.sort_by_deleted
    end
    @post_comments = @post_comments.page(params[:page]).per(20)
  end

  def update
    post_comment = PostComment.find(params[:id])
    # is_deletedをtrueに更新することで論理削除
    post_comment.update(is_deleted: true)
    redirect_to admin_post_comments_path, notice: "コメントを削除しました"
  end

end
