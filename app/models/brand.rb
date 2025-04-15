class Brand < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :official_url, format: { with: /\Ahttps?:\/\/[^\n]+\z/, message: "不正なURLです" }, allow_blank: true
  validates :official_shopping_url, format: { with: /\Ahttps?:\/\/[^\n]+\z/, message: "不正なURLです" }, allow_blank: true

  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
