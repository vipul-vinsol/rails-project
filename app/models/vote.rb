class Vote < ApplicationRecord
  enum vote_type: {
    upvote: 1,
    downvote: -1
  }

  validate :can_only_vote_question_once

  belongs_to :voteable, polymorphic: true
  belongs_to :user

  #FIXME_AB: after_create refresh_net_votes!          #save  net_votes to the votable

  #FIXME_AB: rename
  private def can_only_vote_question_once

    #FIXME_AB: if I have already voted then update existing one
    state = Vote.where(voteable: voteable, user: user).reduce(0) { |sum, v| sum + v.vote_type_before_type_cast }
    if upvote? && state === 1
      errors.add(:base, "You have already upvoted")
    end

    if downvote? && state === -1
      errors.add(:base, "You have already downvoted")
    end
  end

end



