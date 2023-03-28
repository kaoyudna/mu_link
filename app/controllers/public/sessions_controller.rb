class Public::SessionsController < Devise::SessionsController
  before_action :reject_user, only:[:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'ゲストユーザでログインしました。'
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  protected

  def reject_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == true)
        flash[:alert] = "退会済みです。再度ご登録をしてご利用ください。"
        redirect_to new_user_registration_path
      end
    end
  end


end