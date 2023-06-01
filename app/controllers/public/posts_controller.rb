class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  # Spotify Web API へアクセス
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      render 'new'
    end
  end

  def index
    @genres = Genre.all
    @posts = case
    when params[:genre_ids]
      genre_ids = params[:genre_ids].reject(&:blank?)
      # 受け取ったgenre_idsを順次配列から取り出し、genreに紐づく投稿を取得(重複を禁止)
      Kaminari.paginate_array(genre_ids.map { |id| Genre.find(id).posts.get_active_posts }.flatten.uniq(&:id))
    when params[:user_id]
      current_user.posts
    when params[:followings_id]
      current_user.followings_post.get_active_posts
    when params[:liked_post_id]
      current_user.liked_post.get_active_posts
    when params[:word]
      Post.search_for(params[:word]).get_active_posts
    else
      #get_active_posts => 退会していないユーザーの投稿を表示する
      Post.get_active_posts
    end
    @posts = @posts.page(params[:page]).per(12)
  end

  def show
    @post = Post.find(params[:id])
    # 投稿したユーザーが退会していない場合
    if @post.user.is_deleted == false
      @user = @post.user
      @users = @post.favorite_users.where(is_deleted: false)
      @comment = PostComment.new
      @comments = @post.post_comments
      if @user.artist_favorites.count > 0
        artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
        # @artist = 投稿のユーザーがいいねしているアーティスト一覧
        @artists = RSpotify::Artist.find(artists_id)
      end
    # 投稿したユーザーが退会している場合
    else
      redirect_to posts_path, alert: '退会しているユーザーの投稿です'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: '投稿を削除しました'
  end


  private

  def post_params
    params.require(:post).permit(:title,:body,:post_image,genre_ids:[])
  end

  def ensure_correct_user
    post = Post.find(params[:id])
    user = post.user
    unless user == current_user
      redirect_to posts_path, alert: "他のユーザーの投稿は編集できません"
    end
  end

end
