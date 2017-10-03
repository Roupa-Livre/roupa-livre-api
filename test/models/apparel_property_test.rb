# == Schema Information
#
# Table name: apparel_properties
#
#  id                     :integer          not null, primary key
#  apparel_id             :integer
#  cached_category_name   :string
#  category_id            :integer
#  cached_kind_name       :string
#  kind_id                :integer
#  cached_model_name      :string
#  model_id               :integer
#  cached_size_group_name :string
#  size_group_id          :integer
#  cached_size_name       :string
#  size_id                :integer
#  cached_pattern_name    :string
#  pattern_id             :integer
#  cached_color_name      :string
#  color_id               :integer
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class ApparelPropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
