class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
      redirect_to post_path(@post)
    else
      @user = @post.user
      @users = @post.favorite_users
      @comments = @post.post_comments
      if @user.artist_favorites.count > 0
        artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
        @artists = RSpotify::Artist.find(artists_id)
      end
      render 'public/posts/show'
    end
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
