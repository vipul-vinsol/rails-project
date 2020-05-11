class Profile < ApplicationRecord
  belongs_to :user

  #FIXME_AB: Lets create CreditTransaction Model and add signup credit on verification there. Later this model will be polymorphic so that we know why this transaction was done. Also enum of transaction type. like signup, question_posted, etc..
  has_one_attached :avatar

  #FIXME_AB: we should protect profile to be delete. profile should be destroyed only if user is destroyed.
end
