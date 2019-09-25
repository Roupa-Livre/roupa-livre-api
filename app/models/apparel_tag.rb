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

class ApparelTag < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :apparel
  belongs_to :global_tag

  before_validation :check_name_changed

  attr_accessor :name

  def check_name_changed
    if self.name && !self.name.empty? && (!self.global_tag || self.global_tag.name != self.name.downcase)
      self.global_tag = GlobalTag.find_or_create_by(name: self.name.downcase)
    end
  end
end
