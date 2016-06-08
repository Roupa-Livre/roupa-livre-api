# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  user_id    :integer          not null
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatMessage < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  validates_presence_of :chat, :user, :message

  def is_owner(user)
    user.id == user_id
  end
end
