class FeedsController < ApplicationController
  def index
    @questions = Question.published.includes(:topics, :user, :questions_topics)
                  .where(topics: { id: current_user.profile.topic_ids})
                  .paginate(page: params[:page], per_page: ENV['paginator_per_page_count'].to_i) 
                  .order(updated_at: :desc)
  end
end
