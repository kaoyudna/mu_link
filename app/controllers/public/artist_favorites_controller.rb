class Public::ArtistFavoritesController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def create
    favorite = current_user.artist_favorites.new(artist_id: params[:artist_id])
    favorite.save
    @artist = RSpotify::Artist.find(favorite.artist_id)
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id))
  end

  def destroy
    favorite = current_user.artist_favorites.find_by(artist_id: params[:artist_id])
    favorite.destroy
    @artist = RSpotify::Artist.find(favorite.artist_id)
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id))
  end
end
