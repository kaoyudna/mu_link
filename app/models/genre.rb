class Genre < ApplicationRecord

  has_many :user_genres, dependent: :destroy
  has_many :users, through: :user_genres
  has_many :post_genres, dependent: :destroy
  has_many :posts, through: :post_genres
  has_many :group_genres, dependent: :destroy
  has_many :groups, through: :group_genres

  validates :name, presence: true

end
