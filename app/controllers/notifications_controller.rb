class NotificationsController < ApplicationController
  before_action :redirect_root, only: :index

  def index
    @pagy, @notifications = pagy(current_user.notifications.includes(:notifable).order(created_at: :desc), limit: 10)

    current_user.read_notification if @notifications.unread.present?
  end
end
