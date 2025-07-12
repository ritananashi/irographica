class AddLikesCountToReviews < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :likes_count, :integer, default: 0, null: false

    add_index :reviews, :likes_count
  end
end
