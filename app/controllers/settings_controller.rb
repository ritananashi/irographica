class SettingsController < ApplicationController
  before_action :redirect_root, only: :edit

  def edit
    @user = current_user
  end

  def update_setting
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to edit_settings_path, notice: t("users.setting.notice")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
