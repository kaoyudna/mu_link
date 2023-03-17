class Public::ArtistsController < ApplicationController
  before_action :authenticate_user!

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @artists = RSpotify::Artist.search('a', market: 'JP', limit: 4)
     if params[:word].present?
       @artists = RSpotify::Artist.search(params[:word], market: 'JP', limit: 4)
     end
  end

  def show
    @artist = RSpotify::Artist.find(params[:id])
    #Artistモデルが存在しないため、whereメソッドを用いてユーザー一覧を取得
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id))
  end

end
