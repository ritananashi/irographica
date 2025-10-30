class AddReviewsCountToProduct < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :reviews_count, :integer, default: 0, null: false
  end
end
