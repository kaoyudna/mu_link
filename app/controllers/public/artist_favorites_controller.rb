class Public::ArtistFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favorite = current_user.artist_favorites.new(artist_id: params[:artist_id])
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = current_user.artist_favorites.find_by(artist_id: params[:artist_id])
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
