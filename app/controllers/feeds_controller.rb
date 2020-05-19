class FeedsController < ApplicationController
  def index
    @questions = Question.published.includes(:topics)
                  .where(topics: { id: current_user.profile.topic_ids})
                  .paginate(page: params[:page], per_page: 1) 
                  .order(updated_at: :desc)
  end
end
