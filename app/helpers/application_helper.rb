module ApplicationHelper
  def post_review_url(review)
    "https://irographica.com/reviews/#{review.id}"
  end

  def post_profile_url(user)
    "https://irographica.com/users/#{user.account}"
  end
end
