# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           default("ChatMessage")
#

require 'test_helper'

class ChatMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
