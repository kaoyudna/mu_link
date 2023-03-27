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
  validate :introduction_length
  #グループイメージがある場合にバリデーションチェックを行う
  validate :image_group_content_type, if: :was_group_image_attached?

  def introduction_length
    #改行の文字列を除いた文字数を変数に代入(本文が入力されていなければ0が代入される)
    text_length = introduction&.count("^\r\n") || 0
    errors.add(:introduction, "は20文字以内で入力してください") if text_length > 20
  end

  def image_group_content_type
    #ハッシュに利用可能な拡張子を格納
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    #グループイメージの拡張子が上記以外の場合はエラーメッセージを表示
    errors.add(:group_image, 'の拡張子が対応していません') unless group_image.content_type.in?(extension)
  end

  def was_group_image_attached?
    self.group_image.attached?
  end

  def get_group_image(width,height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_fill:[width,height])
  end

  def save_genres(genre_ids)
    #重複を防ぐために現在の保有しているジャンルを削除する(投稿編集機能は実装していないので将来用)
    self.group_genres.destroy_all
    genre_ids.each do |genre_id|
      self.group_genres.create(genre_id: genre_id)
    end
  end

  def user_join?(user)
    group_users.where(user_id: user.id).exists?
  end

  def self.search_for(word)
    Group.where('name LIKE?',"%#{word}%").order(created_at: :desc)
  end

end
