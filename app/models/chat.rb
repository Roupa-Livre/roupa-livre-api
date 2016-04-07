# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  user_1_id       :integer          not null
#  user_2_id       :integer          not null
#  user_1_accepted :boolean
#  user_2_accepted :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Chat < ActiveRecord::Base
  has_one :user_1, :foreign_key => "user_2_id", :class_name => "User"
  has_one :user_2, :foreign_key => "user_2_id", :class_name => "User"

  validates_presence_of :user_1, :user_2
  validates_uniqueness_of :user_1, :scope => :user_2
end
