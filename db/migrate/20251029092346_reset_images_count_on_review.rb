class ResetImagesCountOnReview < ActiveRecord::Migration[7.2]
  def up
    Review.find_each{ |review| review.update_column(:images_count, review.images.count) }
  end

  def down
    Review.update_all(images_count: 0)
  end
end
