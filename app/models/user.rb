class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #ユーザー名の文字数
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  
end
