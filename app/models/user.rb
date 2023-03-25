class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :relationships, class_name: 'Relationship', foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :reverce_of_relationships, class_name: 'Relationship', foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverce_of_relationships, source: :follower
  has_many :post_favorites, dependent: :destroy
  has_many :liked_post, through: :post_favorites, source: :post
  has_many :followings_post, through: :followings, source: :posts
  has_many :artist_favorites, dependent: :destroy
  has_many :music_favorites, dependent: :destroy
  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :group_messages, dependent: :destroy
  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_one_attached :profile_image
  has_one_attached :background_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validate :introduction_length
  validate :image_profile_content_type, if: :was_profile_attached?
  validate :image_background_content_type, if: :was_background_attached?

  def introduction_length
    #改行の文字列を除いた文字数を変数に代入(本文が入力されていなければ0が代入される)
    text_length = introduction&.count("^\r\n") || 0
    errors.add(:introduction, "は20文字以内で入力してください") if text_length > 20
  end

  def image_profile_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:profile_image, 'の拡張子が対応していません') unless profile_image.content_type.in?(extension)
  end

  def image_background_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:background_image, 'の拡張子が対応していません') unless background_image.content_type.in?(extension)
  end

  def was_profile_attached?
    self.profile_image.attached?
  end

  def was_background_attached?
    self.background_image.attached?
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill:[width,height])
  end

  def get_background_image_url()
    unless background_image.attached?
      file_path = Rails.root.join('app/assets/images/background_default.jpg')
      background_image.attach(io: File.open(file_path), filename: 'background_default.jpg', content_type: 'image/jpeg')
    end
    background_image
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def favorited_artist_by?(artist)
    artist_favorites.where(artist_id: artist.id).exists?
  end

  def favorited_music_by?(music)
    music_favorites.where(music_id: music.id).exists?
  end

  def save_genres(genre_ids)
    if genre_ids.present?
      #重複を防ぐために前回のジャンルを削除
      self.user_genres.destroy_all
      #受け取ったジャンルidを配列から取り出す
      genre_ids.each do |genre_id|
        # ユーザージャンルテーブルに受け取った値を保存していく
        self.user_genres.create(genre_id: genre_id)
      end
    else
      self.user_genres.destroy_all
    end
  end

  def self.search_for(word)
    User.where('name LIKE?',"%#{word}%").order(created_at: :desc)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?",current_user.id, id ,'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
        )
        notification.save if notification.valid?
    end
  end

end
