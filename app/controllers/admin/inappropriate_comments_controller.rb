class Admin::InappropriateCommentsController < ApplicationController

  def create
    @inappropriate_comment = InappropriateComment.new(inappropriate_comments_params)
    if @inappropriate_comment.save
      redirect_to request.referer, notice: '不適切なワードを追加しました'
    else
      @inappropriate_comments = InappropriateComment.all
      @post_comments = PostComment.all.order(is_deleted: :asc).order(created_at: :desc).page(params[:page]).per(20)
      render 'admin/post_comments/index'
    end
  end

  def destroy
    inappropriate_comment = InappropriateComment.find(params[:id])
    inappropriate_comment.destroy
    redirect_to request.referer, notice: '不適切なワードを削除しました'
  end

  def inappropriate_comments_params
    params.require(:inappropriate_comment).permit(:comment)
  end

end
