class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @users = User.where(is_deleted: false)
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @users = @genre.users
    elsif params[:word]
      @users = User.search_for(params[:word])
    elsif params[:recommendation_id]
      @user = User.find(params[:recommendation_id])
      @users = User.joins(:artist_favorites)
            # 退会していないユーザーを取得
             .where(users: { is_deleted: false })
            # 同じアーティストにいいねをしているユーザーを取得
             .where(artist_favorites: { artist_id: @user.artist_favorites.pluck(:artist_id) })
            # ログインしているユーザーを除外
             .where.not(id: @user.id)
            # 重複を
             .distinct
             .order(created_at: :desc)
    end
  end

  def show
    @user = User.find(params[:id])
    if @user.is_deleted == false
      @posts = @user.posts.all.order(created_at: :desc)
      if @user.artist_favorites.count > 0
      #ユーザーがいいねしているアーティストのspotify_idを取得
        artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
      #spotify_idからアーティスト情報を取得
        @artists = RSpotify::Artist.find(artists_id)
      end
      if @user.music_favorites.count > 0
        music_id = MusicFavorite.where(user_id: @user.id).pluck(:music_id)
        @musics = RSpotify::Track.find(music_id)
      end
    else
      redirect_to users_path, alert: '退会済みのユーザーです'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @genre = params[:user][:genre_id]
    if @user.update(user_params)
      #UserGenre内にパラメーターで受け取った値が見つからなかった場合ジャンルを保存
      unless @user.genres.find_by(id: @genre)
        @user.save_genre(@genre)
      end
      redirect_to user_path(@user), notice: "プロフィールを編集しました"
    else
      render "edit"
    end
  end

  def unsubscribe
  end


  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image, :background_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
