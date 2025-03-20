class UsersController < ApplicationController
  def show
    @user = User.find_by(account: params[:id])
  end
end
