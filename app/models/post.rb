class Post < ApplicationRecord

  default_scope -> {order(created_at: :desc)}
  
  belongs_to :user
  
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres
  
  has_many :post_favorites, dependent: :destroy
  has_many :favorite_users, through: :post_favorites, source: :user
  
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :post_image

  validates :title, presence: true, length: {maximum: 30}
  # :body_length = 改行のコードを除いた本文の文字数制限
  validate :body_length


  def body_length
    # 与えられたbodyの文字数(改行のコードは除外)を数える
    # bodyがnil(空)の場合はtext_lengthに0を代入
    text_length = body&.count("^\r\n") || 0
    errors.add(:body, "は40文字以内で入力してください") if text_length > 40
    errors.add(:body, "を入力してください") if text_length == 0
  end

  def get_post_image(width,height)
    # post_imageが存在しない場合'default.jpg'を保存
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_fill:[width,height])
  end

  def self.get_active_posts
    # ユーザーステータスが有効の投稿のみ表示
    self.joins(:user).where(users: { is_deleted: false })
  end

  def save_genre(genre_ids)
    # 重複を防ぐために保有しているジャンルを全て削除する
    self.post_genres.destroy_all
    genre_ids.each do |genre_id|
      self.post_genres.create(genre_id: genre_id)
    end
  end

  def favorited_post_by?(user)
    post_favorites.where(user_id: user.id).exists?
  end

  def self.search_for(word)
    Post.where('title LIKE?',"%#{word}%").order(created_at: :desc)
  end

  def create_notification_like!(current_user)
    # すでにいいねされているかを検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, 'like'])
    #　いいねされていない場合にいいね通知を作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
        )
        # 自分の投稿に対するいいねは通知済みとする
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
    end
  end


  def create_notification_comment!(current_user, post_comment_id, visited_id)
    # ログインしているユーザーからのコメント通知を作成
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end


end
