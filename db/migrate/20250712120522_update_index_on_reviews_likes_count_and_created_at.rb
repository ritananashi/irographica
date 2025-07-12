class UpdateIndexOnReviewsLikesCountAndCreatedAt < ActiveRecord::Migration[7.2]
  def change
    remove_index :reviews, column: :likes_count
    add_index :reviews, [:likes_count, :created_at]
  end
end
