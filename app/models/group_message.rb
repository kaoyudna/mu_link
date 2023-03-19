class GroupMessage < ApplicationRecord

  belongs_to :user
  belongs_to :group
  has_many :notifications, dependent: :destroy

  validates :message, presence: true, length: {maximum: 20 }

  def create_notification_group_chat!(current_user, group_id)
  temp_ids = GroupMessage.select(:user_id).where(group_id: group_id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_group_chat!(current_user, group_id, temp_id['user_id'])
    end
  end

  def save_notification_group_chat!(current_user, group_id, visited_id)
    notification = current_user.active_notifications.new(
      group_message_id: id,
      group_id: group_id,
      visited_id: visited_id,
      action: 'group_chat'
    )
    notification.save if notification.valid?
  end

end
