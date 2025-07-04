class UsersController < ApplicationController
  def show
    @user = User.find_by(account: params[:id])
    @pagy, @reviews = pagy(@user.reviews.order(created_at: :desc), limit: 10)
  end

  def bookmarks
    @user = User.find_by(account: params[:id])
    @pagy, @bookmark_reviews = pagy(@user.bookmark_reviews.includes(:user).order(created_at: :desc), limit: 10)
  end

  def following
    @title = "フォロー一覧"
    @user = User.find_by(account: params[:id])
    @pagy, @users = pagy(@user.following, limit: 5)
    render "show_follow"
  end

  def followers
    @title = "フォロワー一覧"
    @user = User.find_by(account: params[:id])
    @pagy, @users = pagy(@user.followers, limit: 5)
    render "show_follow"
  end
end
