class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validate :avatar_can_only_be_image

  def avatar_can_only_be_image
    if avatar.nil? || !avatar.image?
      errors.add(:avatar, "can only be image")
    end 
  end

end