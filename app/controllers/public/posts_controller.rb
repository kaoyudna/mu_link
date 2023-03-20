class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @genre_ids = params[:post][:genre_ids].reject(&:blank?).map(&:to_i)
    @post.user_id = current_user.id
    if @post.save
      @post.save_genre(@genre_ids)
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      render 'new'
    end
  end

  def index
    #投稿テーブルとユーザーテーブルを結合して、会員ステータスが有効のな投稿だけを表示
    @posts = Post.get_active_posts
    @user_posts =  current_user.posts
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @posts = @genre.posts.get_active_posts
    elsif params[:user_id]
      @posts = current_user.posts
    elsif params[:followings_id]
      @posts = current_user.followings_post.get_active_posts
    elsif params[:liked_post_id]
      @posts = current_user.liked_post.get_active_posts
    elsif params[:word]
       @posts = Post.search_for(params[:word]).get_active_posts
    end
  end

  def show
    @post = Post.find(params[:id])
    if @post.user.is_deleted == false
      @user = @post.user
      @users = @post.favorite_users
      @comment = PostComment.new
      @comments = @post.post_comments
      if @user.artist_favorites.count > 0
        artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
        @artists = RSpotify::Artist.find(artists_id)
      end
    else
      redirect_to posts_path, alert: '退会しているユーザーの投稿です'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer, notice: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title,:body,:post_image)
  end
end
