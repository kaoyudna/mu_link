class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genre = Genre.new
    @genres = Genre.all.order(created_at: :desc)
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to request.referer, notice: "ジャンルを作成しました"
    else
      @genres = Genre.all.order(created_at: :desc)
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
    @genres = Genre.all.order(created_at: :desc)
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to request.referer, notice: "ジャンルを編集しました"
    else
      @genres = Genre.all.order(created_at: :desc)
      render :edit
    end
  end

  def destroy
    genre = Genre.find(params[:id])
    genre.destroy
    redirect_to admin_genres_path, notice: "ジャンルを削除しました"
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

end
