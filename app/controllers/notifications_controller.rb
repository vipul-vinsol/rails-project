class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications
                      .paginate(page: params[:page], per_page: ENV['paginator_per_page_count'].to_i)
                      .order(updated_at: :desc)
  end

end