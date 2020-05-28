class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_if_draft?, only: [:edit, :update]
  before_action :is_author?, only: [:edit, :update, :destroy]
  before_action :draft_questions_can_only_been_seen_by_author, only: [:show]
  before_action :check_user_has_enough_credit_to_post_question, only: [:new, :create]
  before_action :can_be_deleted, only: [:destroy]

  def index
    @questions = Question.search(params[:q])
                  .published.includes(:topics, :user)
                  .paginate(page: params[:page], per_page: ENV['paginator_per_page_count'].to_i)
                  .order(updated_at: :desc)
  end

  def new
    @question = Question.new
  end

  def show
  end

  def drafts
    @questions = current_user.questions.draft
                  .paginate(page: params[:page], per_page: 2)
                  .order(updated_at: :desc)
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        @question = current_user.questions.build(question_params)
        @question.save!
        if question_params[:attachment]
          @question.attachment.attach(question_params[:attachment])
        end
        @question.assign_topics(params[:question][:topics])
        redirect_to question_path(@question), notice: t('questions.question_create_success')
      rescue Exception => e
        #FIXME_AB: this won't work render. Read flash.now, flash.keep
        render :edit, alert: e.message.present? ? e.message : ''
        raise ActiveRecord::Rollback, e.message
      end
    end
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      begin
        @question.update!(question_params)
        if question_params[:attachment]
          @question.attachment.attach(question_params[:attachment])
        end
        @question.assign_topics(params[:question][:topics])
        redirect_to question_path(@question), notice: t('questions.question_update_success')
      rescue Exception => e
        render :edit, alert: e.message.present? ? e.message : ''
        raise ActiveRecord::Rollback, e.message
      end
    end
  end

  def destroy
    if @question.destroy
      redirect_back fallback_location: root_path, notice: 'Question deleted successfully'
    else
      redirect_back fallback_location: root_path, alert: @question.errors.messages
    end
  end

  private def set_question
    begin
      @question = Question.find(params[:id])
    rescue Exception => e
      redirect_to root_path, alert: 'Requested resource does not exist' and return
    end
  end

  private def is_author?
    unless @question.posted_by?(current_user)
      redirect_back fallback_location: root_path, alert: "Can't access the resource, permission denied" and return
    end
  end

  private def check_if_draft?
    unless @question.draft?
      redirect_back fallback_location: root_path, alert: 'Only draft questions can be updated' and return
    end
  end

  private def draft_questions_can_only_been_seen_by_author
    if @question.draft? && !@question.posted_by?(current_user)
      redirect_back fallback_location: root_path, alert: "Permission Denied" and return
    end
  end

  private def check_user_has_enough_credit_to_post_question
    unless current_user.has_enough_credits_for_posting_question?
      redirect_back fallback_location: root_path, alert: t('questions.not_enough_credit_to_post_question', credits: ENV['credits_needed_to_ask_question'].to_i.abs)
    end
  end

  private def can_be_deleted?
    unless @question.can_be_deleted?
      redirect_back fallback_location: root_path, alert: 'Can not be deleted' and return
    end
  end

  private def question_params
    params.require(:question).permit(:title, :content, :attachment, :status)
  end
end
