class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :category_id, presence: true

  belongs_to :brand
  has_many :reviews

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  def self.ransackable_associations(auth_object = nil)
    ["brand"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["brand_id", "category_id", "name"]
  end
end
