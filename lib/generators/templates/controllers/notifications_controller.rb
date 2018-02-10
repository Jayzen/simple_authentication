class NotificationsController < ApplicationController
  before_action :logged_in_user
  before_action :set_notifications

  def index
  end
  
  def read
    @notifications.each do |notification|
      notification.update_attribute(:read_at, Time.zone.now)
    end
    redirect_to notifications_path
  end
  private
    def set_notifications
      @notifications = Notification.where(recipient: current_user).unread
    end
end
