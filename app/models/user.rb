class User < ApplicationRecord
  enum role: {
    normal: 0,
    admin: 1
  }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true

  has_one :profile, dependent: :destroy
  has_many :questions, dependent: :restrict_with_error
  has_many :credit_transactions, as: :contentable, dependent: :restrict_with_error
  has_many :transactions, foreign_key: "user_id", class_name: "CreditTransaction"
  #FIXME_AB: add dependent option
  has_many :notifications
  has_many :votes

  private def after_confirmation
    ActiveRecord::Base.transaction do
      self.create_profile!
      self.credit_transactions.signup.create!(
        user_id: id,
        amount: ENV['signup_credits'],
      )
    end
  end

  def recalculate_credits!
    self.credits = transactions.sum(:amount)
    save!
  end

  def has_enough_credits_for_posting_question?
    credits >= ENV['credits_needed_to_ask_question'].to_i.abs
  end

end
