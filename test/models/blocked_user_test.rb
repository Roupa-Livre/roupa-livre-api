# == Schema Information
#
# Table name: blocked_users
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  blocked_user_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class BlockedUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
