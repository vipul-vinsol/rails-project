# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)      not null
#  credits                :integer
#  role                   :integer          default("normal"), not null
#
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
