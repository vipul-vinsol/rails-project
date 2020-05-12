class CreditTransaction < ApplicationRecord
  #FIXME_AB: use hash
  enum reason: %i[signup question_posted question_answered]

  belongs_to :user

  after_save :update_user_credits

  def update_user_credits
    #FIXME_AB: user = self.user is redundent
    user                    = self.user
    #FIXME_AB: user.credit_transactions.sum(:amount)
    tranactional_credit_sum = CreditTransaction.where(user_id: user.id).sum('amount')
    user.credits            = tranactional_credit_sum
    user.save()
  end


  #FIXME_AB: can be like this. move this thing to user.
  #FIXME_AB: private method
  # def update_user_credits
  #   user.recalculate_credits!
  # end

end
