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
require 'push_sender'

class ChatMessage < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  validates_presence_of :chat, :user, :message

  after_create :send_push
  after_create :publish_to_realtime

  def is_owner(user)
    user.id == user_id
  end

  def send_push
    do_send_push(chat.other_recipients(self.user), 'Nova mensagem na troca de peças', self.message, self.user.social_image, 'roupa_new_message', { chat_id: self.chat_id, type: 'message' })
    do_send_push([ self.user ], 'Nova mensagem na troca de peças', self.message, self.user.social_image, 'roupa_new_message', { chat_id: self.chat_id, type: 'message' })
  end

  def publish_to_realtime
    if REDIS
      data = { type: 'message', message: self, chat: self.chat }.to_json
      REDIS.publish 'realtime_msg', data
    end
  end

  protected
    def do_send_push(users, title, message, image, push_collapse_key, extraData)
      ids = Identity.where(provider: 'android', user: users).map { |e| e.uid  }
      PushSender.instance.send_android_push(ids, title, message, image, push_collapse_key, extraData)
    end
end
