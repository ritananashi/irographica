class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :account, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { minimum: 4, maximum: 20 }

  def to_param
    account
  end
end
