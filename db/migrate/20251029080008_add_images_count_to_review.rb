class AddImagesCountToReview < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :images_count, :integer, default: 0, null: false
  end
end
