class Report < ApplicationRecord

  default_scope -> {order(created_at: :desc)}
  #reporter => 通報者
  belongs_to :reporter, class_name: "User"
  #reported => 通報される人
  belongs_to :reported, class_name: "User"

  enum status: {waiting: 0, keep: 1, finish: 2}
  
  validates :reason, presence: true
  validates :url, presence: true
  
end
