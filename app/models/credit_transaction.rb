class CreditTransaction < ApplicationRecord
  enum reason: %i[signup question_posted question_answered]

  belongs_to :user

  after_save :update_user_credits

  def update_user_credits
    user                    = self.user
    tranactional_credit_sum = CreditTransaction.where(user_id: user.id).sum('amount')
    user.credits            = tranactional_credit_sum
    user.save()
  end
end
