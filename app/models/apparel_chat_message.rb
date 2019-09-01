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

class ApparelChatMessage < ChatMessage
  def message_needed?
    false
  end

  def send_push
    recipients = chat.other_non_blocked_recipients(self.user)
    if recipients.length > 0
      do_send_push(recipients, self.user.public_name + ' gostou de mais peças suas...', "#{self.apparels.first.title} tá fazendo sucesso", nil, 'roupa_new_message', { chat_id: self.chat_id, type: 'message' })
    end
  end
end
