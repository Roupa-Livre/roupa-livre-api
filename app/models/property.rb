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

class Property < ActiveRecord::Base
  belongs_to :property_group

  def self.find_name(id, default = "")
    item = Property.where(id: id).first
    item ? item.name : default
  end
end
