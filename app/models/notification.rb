# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  notifyable_type :string(255)
#  notifyable_id   :bigint
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Notification < ApplicationRecord
  enum status: {
    unread: 0,
    read: 1
  }

  belongs_to :user
  belongs_to :notifyable, polymorphic: true
end
