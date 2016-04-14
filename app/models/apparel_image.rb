# == Schema Information
#
# Table name: apparel_images
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  file       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApparelImage < ActiveRecord::Base
  belongs_to :apparel
end
