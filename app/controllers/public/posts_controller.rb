class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

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
    @posts = Post.all.order(created_at: :desc)
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @posts = @genre.posts
    elsif params[:word]
       @posts = Post.search_for(params[:word])
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @users = @post.favorite_users
    @comment = PostComment.new
    @comments = @post.post_comments
    if @user.artist_favorites.count > 0
      artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
      @artists = RSpotify::Artist.find(artists_id)
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:title,:body,:post_image)
  end
end
