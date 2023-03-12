class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.order(created_at: :desc)
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
