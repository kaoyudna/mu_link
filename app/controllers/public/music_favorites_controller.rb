class Public::MusicFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favorite = current_user.music_favorites.new(music_id: params[:music_id])
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = current_user.music_favorites.find_by(music_id: params[:id])
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
