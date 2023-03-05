class Public::ArtistsController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @artists = RSpotify::Artist.search('avicii', limit: 4)
  end

  def show
    @artist = RSpotify::Artist.find(params[:id])
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id))
  end

  def search
    if params[:search].present?
      @searchartists = RSpotify::Artist.search(params[:search], market: 'JP', limit: 4)
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
