class UsersController < ApplicationController
  def show
    @user = User.find_by(account: params[:id])
    @reviews = @user.reviews.order(created_at: "DESC")
  end

  def edit
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to user_path(current_user), notice: t('users.setting.notice')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def bookmarks
    @user = User.find_by(account: params[:id])
    @bookmark_reviews = @user.bookmark_reviews.includes(:user).order(created_at: "DESC")
  end

  def following
    @title = "フォロー一覧"
    @user = User.find_by(account: params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "フォロワー一覧"
    @user = User.find_by(account: params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

end
