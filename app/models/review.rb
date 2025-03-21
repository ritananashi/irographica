class Review < ApplicationRecord
  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 2000 }
  validates :paper, length: { maximum: 50 }
  validates :pen, length: { maximum: 50 }

  belongs_to :user
  belongs_to :product
end
