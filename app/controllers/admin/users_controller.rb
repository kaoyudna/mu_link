class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = case
    when params[:word]
      User.search_for(params[:word])
    else
      User.all.order(is_deleted: :asc).order(created_at: :desc)
    end
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(20)
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
