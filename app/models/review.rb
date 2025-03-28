class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many_attached :images

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 2000 }
  validates :paper, length: { maximum: 50 }
  validates :pen, length: { maximum: 50 }
  validates :images,  total_size: { less_than: 3.megabytes, },
                      limit: { max: 4 }
#                      content_type: { in: ['image/png', 'image/jpeg'], spoofing_protection: true }
end
