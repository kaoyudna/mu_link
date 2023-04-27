class Group < ApplicationRecord

  default_scope -> {order(created_at: :desc)}

  has_many :group_genres, dependent: :destroy
  has_many :genres, through: :group_genres

  has_many :group_messages, dependent: :destroy

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  has_many :notifications, dependent: :destroy

  has_one_attached :group_image


  validates :name, presence: true, length:{maximum: 20}
  # :introduction_length = 改行のコードを除いた紹介文の文字数制限
  validate :introduction_length


  def introduction_length
    # 与えられたintroductionの文字数(改行のコードは除外)を数える
    # introductionがnil(空)の場合はtext_lengthに0を代入
    text_length = introduction&.count("^\r\n") || 0
    errors.add(:introduction, "は30文字以内で入力してください") if text_length > 30
  end

  def get_group_image(width,height)
    # group_imageが存在しない場合'default.jpg'を保存
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_fill:[width,height])
  end

  def user_join?(user)
    group_users.where(user_id: user.id).exists?
  end

  def self.search_for(word)
    Group.where('name LIKE?',"%#{word}%").order(created_at: :desc)
  end

end
