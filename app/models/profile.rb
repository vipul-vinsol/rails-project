class Profile < ApplicationRecord

  # include extend
  # enum
  # macros
  # validations
  # associations
  # callbacks
  # scopes


  validate :avatar_can_only_be_image

  belongs_to :user
  has_one_attached :avatar
  has_and_belongs_to_many :topics


  private def avatar_can_only_be_image
    if avatar.nil? || (avatar.attached? && !avatar.image?)
      errors.add(:avatar, "can only be image")
    end
  end

  def assign_topics(param_topics)
    topics_array = []
    param_topics.select(&:present?).each do |topic_name|
      topics_array << Topic.find_or_initialize_by(name: topic_name)
    end

    self.topics = topics_array
  end

end
