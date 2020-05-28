class CreditTransaction < ApplicationRecord
  enum reason: {
    signup: 0,
    question_posted: 1,
    question_answered: 2
  }

  belongs_to :user
  belongs_to :contentable, polymorphic: true

  after_save :update_user_credits

  private def update_user_credits
    user.recalculate_credits!
  end

end
