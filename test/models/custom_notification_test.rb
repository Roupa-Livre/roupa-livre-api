# == Schema Information
#
# Table name: custom_notifications
#
#  id           :integer          not null, primary key
#  push_title   :string           not null
#  push_message :string           not null
#  title        :string           not null
#  image_url    :string
#  body         :text
#  action_link  :string
#  action_title :string
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CustomNotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
