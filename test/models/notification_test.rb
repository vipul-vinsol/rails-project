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
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
