class Post < ApplicationRecord

  belongs_to :user
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres
  has_many :post_favorites, dependent: :destroy
  has_many :favorite_users, through: :post_favorites, source: :user
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :post_image

  validates :title, presence: true, length: {maximum: 30}
  #改行を含めない文字数制限のバリデーション
  validate :body_length
  validate :image_post_content_type, if: :was_post_image_attached?

  def body_length
    #改行の文字列を除いた文字数を変数に代入(本文が入力されていなければ0が代入される)
    text_length = body&.count("^\r\n") || 0
    errors.add(:body, "は40文字以内で入力してください") if text_length > 40
    errors.add(:body, "を入力してください") if text_length == 0
  end

  def image_post_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:post_image, 'の拡張子が対応していません') unless post_image.content_type.in?(extension)
  end

  def was_post_image_attached?
    self.post_image.attached?
  end

  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_fill:[width,height])
  end

  #ユーザーステータスが有効の投稿のみ表示
  def self.get_active_posts
    self.joins(:user).where(users: { is_deleted: false }).order(created_at: :desc)
  end

  def save_genre(genre_ids)
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
    #　いいねされていない場合に通知レコードを作成
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
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
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
