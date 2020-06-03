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
  validate :check_credits_for_posting_questions, if: :publishing_first_time?
  validate :attachment_can_only_be_pdf
  validate :question_was_in_draft_state, if: -> { title_changed? || content_changed? }, on: :update

  belongs_to :user
  has_one_attached :attachment
  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :contentable, dependent: :restrict_with_error
  has_many :notifications, as: :notifyable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy

  after_save :charge_credit_for_posting_question, if: :publishing_first_time?
  #FIXME_AB: if published? and was unpublished
  after_save :send_notifications_to_users, if: -> { published? }
  after_create :set_slug, if: -> { slug_was.nil? }
  before_destroy :can_be_destroyed?

  private def check_credits_for_posting_questions
    unless user.has_enough_credits_for_posting_question?
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

  def publishing_first_time?
    published? && !already_charged?
  end

  private def already_charged?
    credit_transactions.question_posted.exists?
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

  private def charge_credit_for_posting_question
    credit_transactions.question_posted.create!(
      amount: -ENV['credits_needed_to_ask_question'].to_i,
      user_id: user.id
    )
  end

  private def send_notifications_to_users
    notifications_sent_to = []
    #FIXME_AB: eager load profiles
    topics.each do |topic|
      #FIXME_AB: topic.collect(&:profiles).flatten.uniq
      topic.profiles.each do |profile|
        unless notifications_sent_to.include?(profile)
          profile.user.notifications.unread.create(notifyable: self)
          notifications_sent_to << profile
        end
      end
    end
  end

  def posted_by?(current_user)
    user.id = current_user.id
  end

  def has_attached_pdf?
    attachment.attached? && attachment.attachment.content_type === "application/pdf"
  end

  private def question_was_in_draft_state
    unless status_was === "draft"
      errors.add(:base, 'Can only updated questions in draft state')
    end
  end

  def to_param
    slug
  end

  def vote_count
    votes.reduce(0) { |sum, v| sum + v.vote_type_before_type_cast }
  end
end
