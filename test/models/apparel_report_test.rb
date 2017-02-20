# == Schema Information
#
# Table name: apparel_reports
#
#  id         :integer          not null, primary key
#  apparel_id :integer
#  user_id    :integer
#  number     :string
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

require 'test_helper'

class ApparelReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
