class Public::GroupMessagesController < ApplicationController
  before_action :not_join, only:[:show]

  def show
    @group = Group.find(params[:id])
    @chats = @group.group_messages
    @chat = GroupMessage.new(group_id: @group.id)
  end

  def create
    @chat = current_user.group_messages.new(chat_params)
    @chats = @chat.group.group_messages
    if @chat.save
      # グループチャット通知を作成し、グループメンバーに発信
      @chat.create_notification_group_chat!(current_user, @chat.group_id)
    else
      render 'error'
    end
  end

  def destroy
    @chat = GroupMessage.find(params[:id])
    @chat.destroy
    @chats = @chat.group.group_messages
  end


  private

  def chat_params
    params.require(:group_message).permit(:message, :group_id, :user_id)
  end

  def not_join
    group = Group.find(params[:id])
    # ログインしているユーザーがグループへ参加していない場合、グループ一覧画面へ遷移
    unless current_user.group_users.find_by(group_id: group.id)
      redirect_to groups_path, alert: 'グループへ参加してください'
    end
  end
end
