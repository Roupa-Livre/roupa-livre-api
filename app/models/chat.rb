# == Schema Information
#
# Table name: chats
#
#  id                  :integer          not null, primary key
#  user_1_id           :integer          not null
#  user_2_id           :integer          not null
#  user_1_accepted     :boolean
#  user_2_accepted     :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  closed              :boolean
#  closed_at           :datetime
#  user_1_last_read_at :datetime
#  user_2_last_read_at :datetime
#

require 'push_sender'

class Chat < ActiveRecord::Base
  belongs_to :user_1, :class_name => "User"
  belongs_to :user_2, :class_name => "User"

  validates_presence_of :user_1, :user_2
  validates_uniqueness_of :user_1, :scope => :user_2
  validate :check_blocked_users

  has_many :chat_messages, -> { order('created_at DESC') }, dependent: :destroy
  has_many :chat_apparels, dependent: :destroy
  has_many :apparels, through: :chat_apparels

  after_create :create_initial_messages
  after_create :send_push

  def self.active_by_user(user1, user2)
    chat = Chat.find_by(user_1: user1, user_2: user2, closed: [nil, false])
    chat = Chat.find_by(user_1: user2, user_2: user1, closed: [nil, false]) unless chat
    chat
  end

  def user_apparels(user)
    apparels.where(user: user)
  end

  def mark_as_read(user)
    self.user_1_last_read_at = Time.now if user.id == user_1_id
    self.user_2_last_read_at = Time.now if user.id == user_2_id
    self.save
  end

  def last_read_date(user)
    if user.id == user_1_id && user_1_last_read_at
      user_1_last_read_at
    elsif user.id == user_2_id && user_2_last_read_at
      user_2_last_read_at
    else
      nil
    end
  end

  def is_owner(user)
    user.id == user_1_id || user.id == user_2_id
  end

  def get_last_messages(previous_read_at, user = nil, page_size = 20)
    messages = self.chat_messages
    messages = messages.where('created_at > ?', previous_read_at) if previous_read_at
    messages = messages.where.not(user: user) if user
    messages = messages.limit(page_size) if !previous_read_at
    messages
  end

  def previous_messages(previous_message_id, page_size = 20)
    messages = self.chat_messages.where('id < ?', previous_message_id)
    messages = messages.limit(page_size)
    messages
  end

  def create_chat_apparels
    ApparelRating.where(user: user_1, liked: true, apparel: user_2.apparels).each do |rating|
      self.chat_apparels.find_or_create_by(chat: self, apparel: rating.apparel)
    end
    ApparelRating.where(user: user_2, liked: true, apparel: user_1.apparels).each do |rating|
      self.chat_apparels.find_or_create_by(chat: self, apparel: rating.apparel)
    end
  end

  def other_recipients(user)
    recipients = []
    if user
      recipients.push(user_1) if user_1_id != user.id
      recipients.push(user_2) if user_2_id != user.id
    else
      recipients.push(user_1)
      recipients.push(user_2)
    end
    recipients
  end

  def other_non_blocked_recipients(user)
    recipients = self.other_recipients(user)
    recipients = recipients.select do |other_user|
      blocked_user_ids = other_user.blocked_users.select(:blocked_user_id)
      result = !blocked_user_ids.include?(user.id)
      result
    end
    recipients
  end

  def self.find_or_create_chat(user1, user2, user_1_ratings = [], user_2_ratings = [])
    chat = Chat.active_by_user(user1, user2)
    new_chat = false
    if !chat
      chat = Chat.create(user_1: user1, user_2: user2, user_1_accepted: false, user_2_accepted: false)
      new_chat = true
    end
    chat.create_chat_apparels
    if !new_chat
      chat.create_new_ratings_message(user_1_ratings) if user_1_ratings.length > 0
      chat.create_new_ratings_message(user_2_ratings) if user_2_ratings.length > 0
    end
    chat
  end

  def create_new_ratings_message(new_ratings)
    valid_ratings = []
    new_ratings.each do |rating|
      if ChatMessageApparel.joins(:chat_message)
          .where('chat_id = ?', self.id)
          .where('apparel_id = ?', rating.apparel_id).count == 0
        valid_ratings.push(rating) 
      end
    end
    if valid_ratings.length > 0
      chat_message = ApparelChatMessage.create(chat: self, user: valid_ratings.first.user)
      valid_ratings.each do |rating|
        chat_message.chat_message_apparels.create(chat_message: chat_message, apparel_id: rating.apparel_id)
      end
    end
  end

  def send_push
    if user_1 && user_2
      do_send_push(user_1, 'Combinou!', self.user_2.public_name + ' também gostou das suas peças ...', nil, 'roupa_new_match', { chat_id: self.id, type: 'match' })
      do_send_push(user_2, 'Combinou!', self.user_1.public_name + ' também gostou das suas peças ...', nil, 'roupa_new_match', { chat_id: self.id, type: 'match' })
    end
  end

  def create_initial_messages
    chat_message = InitialApparelChatMessage.create(chat: self)
    self.chat_apparels.each do |chat_apparel|
      chat_message.chat_message_apparels.create(chat_message: chat_message, apparel_id: chat_apparel.apparel_id)
    end
  end

  protected
    def check_blocked_users
      if user_1 && user_2
        result = true
        blocked_user_1_ids = user_1.blocked_users.select(:blocked_user_id)
        if blocked_user_1_ids.include? user_2.id
          errors.add(:user_2, :blocked)
          result = false
        end

        blocked_user_2_ids = user_2.blocked_users.select(:blocked_user_id)
        if blocked_user_2_ids.include? user_1.id
          errors.add(:user_1, :blocked)
          result = false
        end

        return false if !result
      end
    end

    def do_send_push(user, title, message, image, push_collapse_key, extraData)
      android_ids = Device.where(provider: 'android', user: user).map { |e| e.uid  }
      PushSender.instance.send_android_push(android_ids, title, message, image, push_collapse_key, extraData) if android_ids.length

      ios_ids = Device.where(provider: 'ios', user: user).map { |e| e.uid  }
      PushSender.instance.send_ios_push(ios_ids, title, message, image, push_collapse_key, extraData) if ios_ids.length
    end
end
