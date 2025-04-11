class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :account])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :account, :body, :x_account, :instagram_account, :youtube_account])
  end

  def redirect_root
    redirect_to new_user_session_path, alert: "ログインしてください" unless user_signed_in?
  end
end
