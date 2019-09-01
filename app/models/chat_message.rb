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

require 'push_sender'

class ChatMessage < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  has_many :chat_message_apparels, dependent: :destroy
  accepts_nested_attributes_for :chat_message_apparels, :allow_destroy => true

  has_many :apparels, through: :chat_message_apparels

  validates_presence_of :chat
  validates :user, presence: true, if: :user_needed?
  validates :message, presence: true, if: :message_needed?

  after_create :send_push
  # after_create :publish_to_realtime

  def is_owner(user)
    user.id == user_id
  end

  def user_needed?
    true
  end
  def message_needed?
    true
  end

  def send_push
    recipients = chat.other_non_blocked_recipients(self.user)
    if recipients.length > 0
      do_send_push(recipients, self.user.public_name + ' diz...', self.message, nil, 'roupa_new_message', { chat_id: self.chat_id, type: 'message' })
    end
  end

  def publish_to_realtime
    if REDIS
      data = { type: 'message', message: self, chat: self.chat }.to_json
      REDIS.publish 'realtime_msg', data
    end
  end

  protected

    def do_send_push(users, title, message, image, push_collapse_key, extraData)
      android_ids = Device.where(provider: 'android', user: users).map { |e| e.uid  }
      PushSender.instance.send_android_push(android_ids, title, message, image, push_collapse_key, extraData) if android_ids.length

      ios_ids = Device.where(provider: 'ios', user: users).map { |e| e.uid  }
      PushSender.instance.send_ios_push(ios_ids, title, message, image, push_collapse_key, extraData) if ios_ids.length
    end
end
