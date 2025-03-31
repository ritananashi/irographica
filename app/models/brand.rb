class Brand < ApplicationRecord
  validates :name, presence: true
  validates :official_url, format: { with: /\Ahttps?:\/\/[^\n]+\z/, message: "不正なURLです" }, allow_blank: true
  validates :official_shopping_url, format: { with: /\Ahttps?:\/\/[^\n]+\z/, message: "不正なURLです" }, allow_blank: true

  has_many :products
end
