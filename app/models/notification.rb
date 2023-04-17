class Notification < ApplicationRecord

  default_scope -> {order(created_at: :desc)}
  
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true
  belongs_to :group, optional: true
  belongs_to :group_message, optional: true

  # :visitor = 通知を送るユーザー
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  # :visited = 通知を受けるユーザー
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  
end
