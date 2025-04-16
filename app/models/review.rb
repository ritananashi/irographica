class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many_attached :images
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 2000 }
  validates :paper, length: { maximum: 50 }
  validates :pen, length: { maximum: 50 }
  validates :images,  total_size: { less_than: 3.megabytes, },
                      limit: { max: 4 },
                      content_type: { in: ['image/png', 'image/jpeg', 'image/webp'], spoofing_protection: true }

  def self.ransackable_attributes(auth_object = nil)
    ["body", "product_id", "title", "paper", "pen"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product"]
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
