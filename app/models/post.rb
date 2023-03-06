class Post < ApplicationRecord

  belongs_to :user
  has_many :post_genres, dependent: :destroy
  has_many :genres, through: :post_genres

  has_one_attached :post_image

  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit:[width,height]).processed
  end

  def save_genre(genre_id)
    post_genre = Genre.find_by(id: genre_id)
    self.genres << post_genre
  end
end
