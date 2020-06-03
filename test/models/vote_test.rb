# == Schema Information
#
# Table name: votes
#
#  id            :bigint           not null, primary key
#  vote_type     :integer
#  user_id       :bigint
#  voteable_id   :bigint
#  voteable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
