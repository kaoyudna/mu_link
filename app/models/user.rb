class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #ユーザー名の文字数
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  has_many :artist_favorites, dependent: :destroy
  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres
  has_many :posts, dependent: :destroy

  has_one_attached :profile_image

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width,height]).processed
  end

  def favorited_artist_by?(artist)
    artist_favorites.where(artist_id: artist.id).exists?
  end

  def save_genre(genre_id)
    user_genre = Genre.find_by(id: genre_id)
    self.genres << user_genre
  end

end
