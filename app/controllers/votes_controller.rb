class VotesController < ApplicationController
  before_action :set_question

  def upvote
    @vote = @question.votes.upvote.build(user: current_user)
    if @vote.save
      render json: {
        success: true,
        message: "Vote created successfully",
        vote_count: @question.reload.vote_count
      }
    else
      render json: {
        success: false,
        message: @vote.errors.messages
      }
    end
  end

  def downvote
    @vote = @question.votes.downvote.build(user: current_user)
    if @vote.save
      render json: {
        success: true,
        message: "Vote created successfully",
        vote_count: @question.reload.vote_count
      }
    else
      render json: {
        success: false,
        message: @vote.errors.messages
      }
    end
  end


  private def set_question
    @question = Question.find_by_slug(params[:slug])
    unless @question
      render json: {
        success: false,
        message: "Requested Asset doesn't exist"
      } and return
    end
  end
end
