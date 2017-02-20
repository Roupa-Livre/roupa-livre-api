# == Schema Information
#
# Table name: blocked_users
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  blocked_user_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class BlockedUser < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :blocked_user_id
end
