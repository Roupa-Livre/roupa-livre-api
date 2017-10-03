# == Schema Information
#
# Table name: property_groups
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  prop_name          :string
#  property_segment   :string
#  sort_order         :integer
#  parent_id          :integer
#  property_filter    :boolean          default(FALSE)
#  filter_property_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class PropertyGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
