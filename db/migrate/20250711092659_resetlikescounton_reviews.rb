class ResetlikescountonReviews < ActiveRecord::Migration[7.2]
  def up
    Review.find_each { |i| Review.reset_counters(i.id, :likes) }
  end
end
