# == Schema Information
#
# Table name: apparel_tags
#
#  id            :integer          not null, primary key
#  apparel_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  global_tag_id :integer          not null
#

require 'test_helper'

class ApparelTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
