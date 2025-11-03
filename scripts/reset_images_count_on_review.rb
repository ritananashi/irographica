Review.find_each { |review| review.update_column(:images_count, review.images.count) }
