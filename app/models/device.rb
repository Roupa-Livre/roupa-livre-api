# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Device < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uid, :provider, :user
  validates_uniqueness_of :uid, :scope => :provider
end
