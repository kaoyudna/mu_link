class Genre < ApplicationRecord
  
   has_many :user_genres, dependent: :destroy
   has_many :post_genres, dependent: :destroy
end
