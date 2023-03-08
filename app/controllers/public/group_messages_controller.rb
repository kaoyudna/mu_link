class Public::GroupMessagesController < ApplicationController
  before_action :not_join, only:[:show]

  def show
    @group = Group.find(params[:id])
    @chats = @group.group_messages
    @chat = GroupMessage.new(group_id: @group.id)
  end

  def create
    @chat = current_user.group_messages.new(chat_params)
    @chat.save
    redirect_back(fallback_location: root_path)
  end

  private

  def chat_params
    params.require(:group_message).permit(:message, :group_id, :user_id)
  end

  def not_join
    group = Group.find(params[:id])
    unless current_user.group_users.find_by(group_id: group.id)
      redirect_to groups_path
    end
  end
end
