class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.order(is_deleted: :asc).order(created_at: :desc)
    if params[:word]
      @users = User.search_for(params[:word])
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to request.referer, notice: "ユーザーステータスを更新しました"
  end

  private

  def user_params
    params.require(:user).permit(:is_deleted)
  end
end
