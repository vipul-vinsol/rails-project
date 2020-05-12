class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validate :avatar_can_only_be_image

  #FIXME_AB: private method
  def avatar_can_only_be_image
    #FIXME_AB: exception coming in confirming account
    if avatar.nil? || !avatar.image?
      errors.add(:avatar, "can only be image")
    end
  end

end
