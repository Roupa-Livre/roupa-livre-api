# == Schema Information
#
# Table name: apparel_tags
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class ApparelTag < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :apparel
end
