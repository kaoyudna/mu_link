class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inappropriate_comments = InappropriateComment.all
    @inappropriate_comment = InappropriateComment.new
    @post_comments = case
    when params[:post_id]
      PostComment.where(post_id: params[:post_id])
    when params[:comment_id]
        post_comments = PostComment.with_inappropriate_comments
        Kaminari.paginate_array(post_comments)
    when params[:word]
      PostComment.search_for(params[:word])
    else
      PostComment.sort_by_deleted
    end
    @post_comments = @post_comments.page(params[:page]).per(20)
  end

  def update
    post_comment = PostComment.find(params[:id])
    post_comment.update(is_deleted: true)
    redirect_to admin_post_comments_path, notice: "コメントを削除しました"
  end

end
