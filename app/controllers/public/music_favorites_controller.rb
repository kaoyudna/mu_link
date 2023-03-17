class Public::MusicFavoritesController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def create
    favorite = current_user.music_favorites.new(music_id: params[:music_id])
    favorite.save
    @music = RSpotify::Track.find(favorite.music_id)
  end

  def destroy
    favorite = current_user.music_favorites.find_by(music_id: params[:id])
    favorite.destroy
    @music = RSpotify::Track.find(favorite.music_id)
  end
end
