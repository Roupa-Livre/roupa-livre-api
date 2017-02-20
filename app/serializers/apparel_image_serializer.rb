# == Schema Information
#
# Table name: apparel_images
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  file       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort_order :integer
#  deleted_at :datetime
#

class ApparelImageSerializer < ActiveModel::Serializer
  attributes :id, :file_url

  def file_url
    (object.file_identifier.start_with?("data:") ) ? object.file_identifier : object.file_url
  end
end
