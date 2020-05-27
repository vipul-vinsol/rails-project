class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_if_draft?, only: [:edit, :update]
  before_action :is_author?, only: [:edit, :update, :destroy]
  before_action :draft_questions_can_only_been_seen_by_author, only: [:show]
  before_action :check_user_has_enough_credit_to_post_question, only: [:new]
  before_action :can_be_deleted, only: [:destroy]

  def index
    @questions = Question.search(params[:q]).published
                  .includes(:topics)
                  .paginate(page: params[:page], per_page: 3) 
                  .order(updated_at: :desc)
  end

  def new
    @question = Question.new
  end

  def show
  end

  def user_draft
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
        if @question.initial_publish?
          @question.credit_transactions.create!(
            amount: ENV['credits_needed_to_ask_question'], 
            reason: CreditTransaction::reasons[:question_posted],
            user_id: current_user.id        
          )
        end
        redirect_to question_path(@question), notice: t('questions.question_create_success')
      rescue Exception => e
        render :edit
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
        render :edit
        raise ActiveRecord::Rollback, e.message
      end
    end
  end

  def destroy
    @question.destroy
  end

  private def set_question
    begin
      @question = Question.find(params[:id])
    rescue Exception => e
      redirect_to '/', alert: 'Requested resource does not exist' and return
    end
  end

  private def is_author?
    unless current_user.question_ids.include?(params[:id].to_i)
      redirect_back fallback_location: '/', alert: "Can't access the resource, permission denied" and return
    end
  end

  private def check_if_draft?
    unless @question.draft?
      redirect_back fallback_location: '/', alert: 'Only draft questions can be updated' and return
    end
  end

  private def draft_questions_can_only_been_seen_by_author
    @question.draft? && is_author?
  end

  private def check_user_has_enough_credit_to_post_question
    current_user.enough_credits_for_posting_question?    
  end

  private def can_be_deleted?
    unless @question.can_be_deleted?
      redirect_back fallback_location: '/', alert: 'Can not be deleted' and return
    end
  end

  def question_params
    params.require(:question).permit(:title, :content, :attachment, :status)
  end
end
