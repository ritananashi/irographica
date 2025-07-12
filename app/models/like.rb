class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review, counter_cache: true

  has_one :notification, as: :notifable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :review_id }
end
