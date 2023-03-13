class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  def self.search_for(word)
    PostComment.where('comment LIKE?',"%#{word}%").order(created_at: :desc)
  end

end
