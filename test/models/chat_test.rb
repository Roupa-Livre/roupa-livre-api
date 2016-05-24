# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  user_1_id       :integer          not null
#  user_2_id       :integer          not null
#  user_1_accepted :boolean
#  user_2_accepted :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  closed          :boolean
#  closed_at       :datetime
#

require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
