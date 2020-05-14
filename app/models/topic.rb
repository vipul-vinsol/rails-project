class Topic < ApplicationRecord
  has_and_belongs_to_many :profiles

  validates :name, presence: true
  validates :name, uniqueness: true, allow_blank: true
end