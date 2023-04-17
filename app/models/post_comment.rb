class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true, length: {maximum: 20}

  def self.search_for(word)
    PostComment.where('comment LIKE?',"%#{word}%").order(created_at: :desc)
  end

  def self.sort_by_deleted
    #作成日時が新しい順に表示し、論理削除済みのコメントは下の行に配置する
    self.all.order(is_deleted: :asc).order(created_at: :desc)
  end
  
  def self.with_inappropriate_comments
    #検索結果を入れる配列を用意
    post_comments = []
    #不適切なコメントを配列から取り出す
    InappropriateComment.pluck(:comment).each do |comment|
      #結果を配列へ追加していく
      post_comments.concat(where('comment LIKE ?', "%#{comment}%").order(created_at: :desc))
    end
    #上記の処理が完了した後に変数内の重複したidを除外
    post_comments.uniq(&:id)
  end

end
