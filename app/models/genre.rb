class Genre < ApplicationRecord

   has_many :user_genres, dependent: :destroy
   has_many :users, through: :user_genres
   has_many :post_genres, dependent: :destroy
   has_many :posts, through: :post_genres
end
