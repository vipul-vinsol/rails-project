class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true

  has_one :profile, dependent: :destroy

  #FIXME_AB: use dependent: restrict_with_error
  has_many :credit_transactions

  def after_confirmation
    #FIXME_AB: wrap in db transaction

    #FIXME_AB: self.build_profile
    self.profile = Profile.new
    self.save()

    #FIXME_AB: credit_transactions.create(amount: ENV[], reason: CreditTransaction::reasons[:signup])
    creditTransaction = CreditTransaction.new(amount: ENV['signup_credits'], user_id: self.id)
    creditTransaction.signup!
  end
end
