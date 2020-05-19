class Question < ApplicationRecord
  acts_as_paranoid
  
  include BasicPresenter::Concern

  enum status: {
    draft: 0,
    published: 1
  }

  validates :title, :content, :status, presence: true
  validates :title, uniqueness: {
    case_sensitive: false
  }, allow_blank: true
  validate :check_credits_for_posting_questions, if: :initial_publish?
  validate :attachment_can_only_be_pdf

  belongs_to :user
  has_one_attached :attachment
  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :contentable, dependent: :restrict_with_error

  after_create :set_slug

  private def check_credits_for_posting_questions
    if user.enough_credits_for_posting_question?
      errors.add(:base, I18n.t('questions.not_enough_credit_to_post_question', credits: ENV['credits_needed_to_ask_question'].to_i.abs))
    end
  end

  private def attachment_can_only_be_pdf
    if attachment.nil? && attachment.content_type != "application/pdf"
      errors.add(:attachment, I18n.t('questions.question_attachment_can_only_be_pdf'))
    end
  end

  private def set_slug
    self.slug = "#{id}-#{title.parameterize}"
    save
  end

  def initial_publish?
    published? and !already_published?
  end

  private def already_published?
    credit_transactions.find_by_reason(CreditTransaction::reasons[:question_posted]) != nil
  end

  private def can_be_destroyed?
    true
  end

  def assign_topics(param_topics)
    topics_array = []
    param_topics.select(&:present?).each do |topic_name|
      topics_array << Topic.find_or_initialize_by(name: topic_name)
    end

    self.topics = topics_array
  end

  def self.search(title_string)
    if title_string.present?
      where("title LIKE ?","%#{title_string}%")
    else
      self
    end
  end

end
