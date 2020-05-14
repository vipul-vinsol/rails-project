class Topic < ApplicationRecord
  has_and_belongs_to_many :profiles

  validates :name, presence: true
  #FIXME_AB: whenever use uniqueness always think about case sensitive. topic should be case insensitive.
  validates :name, uniqueness: true, allow_blank: true
end
