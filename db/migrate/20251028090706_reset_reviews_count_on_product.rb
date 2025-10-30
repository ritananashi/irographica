class ResetReviewsCountOnProduct < ActiveRecord::Migration[7.2]
  def up
    Product.find_each { |i| Product.reset_counters(i.id, :reviews) }
  end
end
