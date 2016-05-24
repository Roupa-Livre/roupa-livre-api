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
#  closed          :boolean
#  closed_at       :datetime
#

class Chat < ActiveRecord::Base
  has_one :user_1, :foreign_key => "user_2_id", :class_name => "User"
  has_one :user_2, :foreign_key => "user_2_id", :class_name => "User"

  validates_presence_of :user_1, :user_2
  validates_uniqueness_of :user_1, :scope => :user_2

  def self.active_by_user(user1, user2)
    chat = Chat.find_by(user_1: user1, user_2: user2)
    chat = Chat.find_by(user_1: user2, user_2: user1) unless chat
    chat
  end

  def self.find_or_create_chat(user1, user2)
    chat = Chat.active_by_user(user1, user2)
    if !chat
      chat = Chat.create(user_1: user1, user_2: user2, user_1_accepted: false, user_2_accepted: false)
      # Cria ou não 
    end
  end
end
