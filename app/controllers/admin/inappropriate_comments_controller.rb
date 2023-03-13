class Admin::InappropriateCommentsController < ApplicationController

  def create
    inappropriate_comment = InappropriateComment.new(inappropriate_comments_params)
    inappropriate_comment.save
    redirect_to request.referer, notice: '不適切なワードを追加しました'
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
