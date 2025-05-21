class NotificationsController < ApplicationController
  before_action :redirect_root, only: :index

  def index
    @notifications = current_user.notifications.order(created_at: "DESC").all

    current_user.read_notification if @notifications.unread.present?
  end
end
