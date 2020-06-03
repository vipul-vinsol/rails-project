class NotificationsController < ApplicationController
  before_action :set_notification, only: [:markseen, :destory]
  before_action :check_ownership, only: [:markseen, :destory]

  def index
    @notifications = current_user.notifications
                      .paginate(page: params[:page], per_page: ENV['paginator_per_page_count'].to_i)
                      .order(updated_at: :desc)
  end

  def markseen
    begin
      @notification.read!
      redirect_back fallback_location: root_path, notice: "Success"
    rescue => e
      redirect_back fallback_location: root_path, alert: @notification.errors.messages
    end
  end

  def destroy
    if @notification.destroy
      redirect_back fallback_location: root_path, notice: 'Notification deleted successfully'
    else
      redirect_back fallback_location: root_path, alert: @notification.errors.messages
    end
  end

  #FIXME_AB: you can skip this before action check if you do following in set_notification
  #FIXME_AB: current_user.notifications.find....
  private def check_ownership
    unless @notification.user === current_user
      redirect_to root_path, alert: 'Permission Denied' and return
    end
  end

  private def set_notification
    @notification = Notification.find(params[:id])
    unless @notification
      redirect_to root_path, alert: 'Requested resource does not exist' and return
    end
  end
end
