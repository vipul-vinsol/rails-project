# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Topic < ApplicationRecord
  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :question

  validates :name, presence: true
  validates :name, uniqueness: {
    case_sensitive: false
  }, allow_blank: true
end
