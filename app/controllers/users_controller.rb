class UsersController < ApplicationController
  def show
    @user = User.find_by(account: params[:id])
    @reviews = @user.reviews.order(created_at: "DESC")
  end

  def bookmarks
    @user = User.find_by(account: params[:id])
    @bookmark_reviews = @user.bookmark_reviews.includes(:user).order(created_at: "DESC")
  end

  def following
    @title = "フォロー一覧"
    @user = User.find_by(account: params[:id])
    @users = @user.following
    render "show_follow"
  end

  def followers
    @title = "フォロワー一覧"
    @user = User.find_by(account: params[:id])
    @users = @user.followers
    render "show_follow"
  end
end
