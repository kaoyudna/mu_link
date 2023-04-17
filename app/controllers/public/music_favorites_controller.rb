class Public::MusicFavoritesController < ApplicationController
  before_action :authenticate_user!

  # Spotify Web API へアクセス
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def create
    favorite = current_user.music_favorites.new(music_id: params[:music_id])
    favorite.save
    # 以下、ajax用の記述
    # いいねされたmusicを取得
    @music = RSpotify::Track.find(favorite.music_id)
  end

  def destroy
    favorite = current_user.music_favorites.find_by(music_id: params[:id])
    favorite.destroy
    # 以下、ajax用の記述
    # いいねされていたmusicを取得
    @music = RSpotify::Track.find(favorite.music_id)
  end
end
