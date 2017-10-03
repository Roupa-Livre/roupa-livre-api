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

class PropertyGroupSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :prop_name, :property_segment, :sort_order, :parent_id, :property_filter, :filter_property_id

  has_many :properties

  def properties
    self.object.properties
  end
end
