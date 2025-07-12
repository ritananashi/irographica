module SortStatus
  extend ActiveSupport::Concern

  included do
    scope :latest, -> { order(created_at: :desc) }
    scope :old, -> { order(created_at: :asc) }
    scope :likes, -> { order(likes_count: :desc, created_at: :desc) }
  end
end
