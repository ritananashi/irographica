class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :account, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { minimum: 4, maximum: 20 }
  validates :body, length: { maximum: 500 }
  validates :x_account, format: { with: /\Ahttps?:\/\/x.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true
  validates :instagram_account, format: { with: /\Ahttps?:\/\/www.instagram.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true
  validates :youtube_account, format: { with: /\Ahttps?:\/\/youtube.com\/[^\n]+\z/ , message: "のURLを入力してください" }, allow_blank: true

  has_many :reviews
  has_one_attached :avatar

  def to_param
    account
  end
end
