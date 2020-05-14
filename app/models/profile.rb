class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_and_belongs_to_many :topics

  validate :avatar_can_only_be_image

  private def avatar_can_only_be_image
    if avatar.nil? || (avatar.attached? && !avatar.image?)
      errors.add(:avatar, "can only be image")
    end
  end

end