class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #ユーザー名の文字数
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  
  has_many :artist_favorites, dependent: :destroy
  
  def favorited_artist_by?(artist)
    artist_favorites.where(artist_id: artist.id).exists?
  end
  
end
