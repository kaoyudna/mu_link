class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @genre = params[:post][:genre_id]
    @post.user_id = current_user.id
    if @post.save
      @post.save_genre(@genre)
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def index
  end

  def show
  end

  private

  def post_params
    params.require(:post).permit(:title,:body,:post_image)
  end
end
