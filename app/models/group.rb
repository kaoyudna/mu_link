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
  #紹介文は改行が可能なため、改行のコードを除いた文字数制限のバリデーション
  validate :introduction_length
  #意図しない拡張子のファイルアップロードを制限するバリデーション
  validate :image_group_content_type, if: :was_group_image_attached?

  def introduction_length
    #与えられた'introduction'の文字数に応じてエラーメッセージを表示する
    #もし'introduction'の文字数が30文字以上であれば文字数制限のメッセージを返す
    text_length = introduction&.count("^\r\n") || 0
    errors.add(:introduction, "は30文字以内で入力してください") if text_length > 30
  end

  def image_group_content_type
    #
    extension = ['image/png', 'image/jpg', 'image/jpeg']
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
