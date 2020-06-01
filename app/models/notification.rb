class Notification < ApplicationRecord
  enum status: {
    unread: 0,
    read: 1
  }

  belongs_to :user
  belongs_to :notifyable, polymorphic: true
end
