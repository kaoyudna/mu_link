class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.find_by(post_id: post.id)
    comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
