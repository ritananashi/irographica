class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :ink_recipes, dependent: :destroy
  accepts_nested_attributes_for :ink_recipes, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 2000 }
  validates :paper, length: { maximum: 50 }
  validates :pen, length: { maximum: 50 }
  validates :images,  total_size: { less_than: 3.megabytes, },
                      limit: { max: 4 },
                      content_type: { in: ['image/png', 'image/jpeg', 'image/webp'], spoofing_protection: true }

  ransack_alias :review_search, :title_or_body_or_product_name_or_paper_or_pen_or_product_brand_name

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
