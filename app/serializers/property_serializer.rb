# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  sort_order :integer
#  segment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PropertySerializer < ActiveModel::Serializer
  attributes :id, :code, :name
end
