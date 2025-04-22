module UsersHelper
  def post_profile_url(user)
    "https://irographica.com/users/#{user.account}"
  end
end
