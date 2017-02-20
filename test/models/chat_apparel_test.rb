# == Schema Information
#
# Table name: chat_apparels
#
#  id         :integer          not null, primary key
#  chat_id    :integer
#  apparel_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

require 'test_helper'

class ChatApparelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
