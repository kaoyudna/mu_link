class GroupMessage < ApplicationRecord

  belongs_to :user
  belongs_to :group

  validates :message, presence: true, length: {maximum: 20 }
end
