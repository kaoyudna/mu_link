class Public::ArtistFavoritesController < ApplicationController
  before_action :authenticate_user!

  # Spotify Web API へアクセス
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def create
    favorite = current_user.artist_favorites.new(artist_id: params[:artist_id])
    favorite.save
    # 以下、Ajax用の記述
    # @artist = いいねされたアーティストを取得
    @artist = RSpotify::Artist.find(favorite.artist_id)
    # @users = 上記のアーティストをいいねしている他のユーザーを取得
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id)).where(is_deleted: false)
  end

  def destroy
    favorite = current_user.artist_favorites.find_by(artist_id: params[:artist_id])
    favorite.destroy
    # 以下、Ajax用の記述
    # @artist = いいねされていたアーティストを取得
    @artist = RSpotify::Artist.find(favorite.artist_id)
    # @users = 上記のアーティストをいいねしている他のユーザーを取得
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id)).where(is_deleted: false)
  end
end
