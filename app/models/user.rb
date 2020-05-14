class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true

  has_one :profile, dependent: :destroy

  has_many :credit_transactions, dependent: :restrict_with_error

  private def after_confirmation
    ActiveRecord::Base.transaction do
      self.create_profile!
      #FIXME_AB: signup_credits should be rquired in figaro
      self.credit_transactions.create!(amount: ENV['signup_credits'], reason: CreditTransaction::reasons[:signup])
    end
  end

  def recalculate_credits!
    self.credits = credit_transactions.sum(:amount)
    save!
  end

end
