module ApplicationHelper
  def post_review_url(review)
    "https://inklog.fly.dev/reviews/#{review.id}"
  end

  def post_profile_url(user)
    "https://inklog.fly.dev/users/#{user.account}"
  end
end
