class UsersController < ApplicationController
  def show
    @user = User.find_by(account: params[:id])
    @reviews = @user.reviews.order(created_at: "DESC")
  end
end
