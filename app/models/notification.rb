class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifable, polymorphic: true

  validates :user_id, presence: true
  validates :notifable_id, presence: true
  validates :notifable_type, presence: true

  scope :unread, -> { where(read: false) }
end
