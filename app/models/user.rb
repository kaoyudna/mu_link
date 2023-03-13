class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #ユーザー名の文字数
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

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

  has_one_attached :profile_image
  has_one_attached :background_image

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill:[width,height]).processed
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

  def save_genre(genre_id)
    user_genre = Genre.find_by(id: genre_id)
    self.genres << user_genre
  end

  def self.search_for(word)
    User.where('name LIKE?',"%#{word}%").order(created_at: :desc)
  end

  
end
