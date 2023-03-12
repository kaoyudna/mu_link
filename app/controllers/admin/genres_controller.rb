class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def new
  end

  def index
    @genre = Genre.new
    @genres = Genre.all.order(created_at: :desc)
  end

  def create
    genre = Genre.new(genre_params)
    genre.save
    redirect_to request.referer, notice: "ジャンルを作成しました"
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    genre = Genre.find(params[:id])
    genre.update(genre_params)
    redirect_to request.referer, notice: "ジャンルを編集しました"
  end

  def destroy
    genre = Genre.find(params[:id])
    genre.destroy
    redirect_to request.referer, notice: "ジャンルを削除しました"
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

end
