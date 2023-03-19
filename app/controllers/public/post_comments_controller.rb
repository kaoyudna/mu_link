class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    @comments = @post.post_comments
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id, @post.user_id)
    else
      render 'error'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.find_by(post_id: @post.id, id: params[:id])
    comment.destroy
    @comments = @post.post_comments
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
