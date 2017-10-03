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

class PropertyGroup < ActiveRecord::Base
  has_many :children, class_name: "PropertyGroup", foreign_key: "parent_id"
  belongs_to :parent, class_name: "PropertyGroup"

  def properties
    Property.where(segment: property_segment).order(:sort_order)
  end

end
