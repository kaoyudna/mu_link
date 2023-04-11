class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @genres = Genre.all
    @users = case
    when params[:genre_ids]
      genre_ids = params[:genre_ids].reject(&:blank?)
      Kaminari.paginate_array(genre_ids.map { |id| Genre.find(id).users.where.not(id: current_user.id) }.flatten.uniq(&:id))
    when params[:word]
      User.search_for(params[:word]).where.not(id: current_user.id)
    when params[:recommendation_id]
      user = User.find(params[:recommendation_id])
      User.joins(:artist_favorites)
            # 退会していないユーザーを取得
             .where(users: { is_deleted: false })
            # 同じアーティストにいいねをしているユーザーを取得
             .where(artist_favorites: { artist_id: user.artist_favorites.pluck(:artist_id) })
            # ログインしているユーザーを除外
             .where.not(id: user.id)
            # 重複を禁止
             .distinct
             .order(created_at: :desc)
    else
      User.where(is_deleted: false).where.not(id: current_user.id).page(params[:page]).per(12)
    end
    @users = @users.page(params[:page]).per(12)
  end

  def show
    @user = User.find(params[:id])
    if @user.is_deleted == false
      @notifications = current_user.passive_notifications.page(params[:page]).per(20)
      @posts = @user.posts.all.order(created_at: :desc).page(params[:page]).per(12)
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
  @genre_ids = params[:user][:genre_ids].reject(&:blank?).map(&:to_i)
    if @user.update(user_params)
      @user.save_genres(@genre_ids)
      redirect_to user_path(@user), notice: "プロフィールを編集しました"
    else
      render "edit"
    end
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
