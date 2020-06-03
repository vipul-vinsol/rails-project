# == Schema Information
#
# Table name: credit_transactions
#
#  id               :bigint           not null, primary key
#  amount           :integer
#  reason           :integer
#  user_id          :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  contentable_type :string(255)
#  contentable_id   :bigint
#
require 'test_helper'

class CreditTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
