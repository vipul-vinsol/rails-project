# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  content    :text(65535)
#  status     :integer
#  slug       :string(255)
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
