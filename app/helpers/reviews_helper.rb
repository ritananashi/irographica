module ReviewsHelper
  def post_review_url(review)
    "https://irographica.com/reviews/#{review.id}"
  end
end
