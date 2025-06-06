class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter2]

  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_reviews, through: :bookmarks, source: :review
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 10 }
  validates :account, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { minimum: 4, maximum: 20 }
  validates :body, length: { maximum: 500 }
  validates :avatar, size: { less_than: 1.megabytes, },
                      content_type: { in: ['image/png', 'image/jpeg', 'image/webp'], spoofing_protection: true }
  validates :x_account, format: { with: /\Ahttps?:\/\/x.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true
  validates :instagram_account, format: { with: /\Ahttps?:\/\/www.instagram.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true
  validates :youtube_account, format: { with: /\Ahttps?:\/\/youtube.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true

  def to_param
    account
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = User.dummy_email(auth)
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.account = auth.info.nickname
      process_avatar = ImageProcessing::MiniMagick.source(auth.info.image).resize_to_fit(300, 300).convert("webp").call
      filename_base = File.basename(auth.info.image, ".*")
      user.avatar.attach(io: process_avatar, filename: "#{filename_base}.webp", content_type: "image/webp")
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def bookmark(review)
    bookmark_reviews << review
  end

  def unbookmark(review)
    bookmark_reviews.destroy(review)
  end

  def bookmarked_by?(review)
    bookmark_reviews.include?(review)
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def create_notification(type)
    notifications.create!(notifable_id: type.id, notifable_type: type.class.name)
  end

  def read_notification
    notifications.unread.update_all(read: true)
  end
end
