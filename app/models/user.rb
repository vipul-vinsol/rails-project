class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true
  
  has_one :profile, dependent: :destroy
  has_many :credit_transactions

  def after_confirmation
    self.profile = Profile.new
    self.save()

    creditTransaction = CreditTransaction.new(amount: ENV['signup_credits'], user_id: self.id)
    creditTransaction.signup!
  end
end