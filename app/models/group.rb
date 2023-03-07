class Group < ApplicationRecord

  has_many :group_genres, dependent: :destroy
  has_many :genres, through: :group_genres
  has_many :group_messages, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  has_one_attached :group_image

  def get_group_image(width,height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_fill:[width,height]).processed
  end

  def save_genre(genre_id)
    group_genre = Genre.find_by(id: genre_id)
    self.genres << group_genre
  end

  def user_join?(user)
    group_users.where(user_id: user.id).exists?
  end

end
