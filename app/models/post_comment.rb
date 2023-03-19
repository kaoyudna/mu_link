class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true, length: {maximum: 20}

  def self.search_for(word)
    PostComment.where('comment LIKE?',"%#{word}%").order(created_at: :desc)
  end

end
