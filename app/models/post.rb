class Post < ApplicationRecord

  belongs_to :user
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres
  has_many :post_favorites, dependent: :destroy
  has_many :favorite_users, through: :post_favorites, source: :user
  has_many :post_comments, dependent: :destroy

  has_one_attached :post_image

  validates :title, presence: true, length: {maximum: 20}
  validates :body, presence: true, length: {maximum: 40}

  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_fill:[width,height]).processed
  end

  def save_genre(genre_id)
    post_genre = Genre.find_by(id: genre_id)
    self.genres << post_genre
  end

  def favorited_post_by?(user)
    post_favorites.where(user_id: user.id).exists?
  end

  def self.search_for(word)
    Post.where('title LIKE?',"%#{word}%").order(created_at: :desc)
  end
end
