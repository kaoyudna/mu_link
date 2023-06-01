class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  # Spotify Web API へアクセス
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @genres = Genre.all
    @users = case
    when params[:genre_ids]
      genre_ids = params[:genre_ids].reject(&:blank?)
      # 受け取ったgenre_idsを順次配列から取り出し、genreに紐づくユーザーを取得(重複とログインしているユーザーの表示を禁止)
      Kaminari.paginate_array(genre_ids.map { |id| Genre.find(id).users.where.not(id: current_user.id) }.flatten.uniq(&:id))
    when params[:word]
      User.search_for(params[:word]).where.not(id: current_user.id)
    when params[:user_id]
      # @users = 同じアーティストをフォローしているユーザー一覧
      User.similar_users(params[:user_id])
    else
      User.where(is_deleted: false).where.not(id: current_user.id).page(params[:page]).per(12)
    end
    @users = @users.page(params[:page]).per(12)
  end

  def show
    @user = User.find(params[:id])
    # ユーザーが退会していない場合
    if @user.is_deleted == false
      #@notifications = 受け取った通知一覧
      @notifications = current_user.passive_notifications.page(params[:page]).per(20)
      @posts = @user.posts.all.page(params[:page]).per(12)
      if @user.artist_favorites.count > 0
        # ユーザーがいいねしているアーティストのspotify_idを取得
        artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
        # spotify_idからアーティスト情報を取得
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
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを編集しました"
    else
      render "edit"
    end
  end


  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image, :background_image, genre_ids:[])
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
