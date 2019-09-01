# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           default("ChatMessage")
#

class InitialApparelChatMessage < ChatMessage
  def user_needed?
    false
  end
  def message_needed?
    false
  end

  def send_push
  end

  def self.check_all
    Chat.all.each do |chat|
      if chat.chat_messages.where(type: 'InitialApparelChatMessage').length == 0
        chat.create_initial_messages
      end
    end
  end
end
