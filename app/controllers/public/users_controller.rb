class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
  end

  def show
    @user = User.find(params[:id])
    #ユーザーがいいねしているアーティストのspotify_idを取得
    artists_id = ArtistFavorite.where(user_id: @user.id).pluck(:artist_id)
    #spotify_idからアーティスト情報を取得
    @artists = RSpotify::Artist.find(artists_id)
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
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
