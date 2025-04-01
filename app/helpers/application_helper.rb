module ApplicationHelper
  def post_review_url(review)
    "https://inklog.fly.dev/reviews/#{review.id}"
  end
end
