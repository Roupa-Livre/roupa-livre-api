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

class ChatSerializer < ActiveModel::Serializer
  attributes :id, :user_1_accepted, :user_2_accepted, :other_user, :name, :last_read_at, :others_last_read_at, :unread_messages_count, :total_messages_count, :last_message_sent_at

  has_many :user_1
  has_many :user_2

  # def attributes(*args)
  #   data = super
  #   data[:messages] = messages if @options[:include_messages].present? && @options[:include_messages]
  #   data
  # end

  def other_user
    if object.user_1_id == current_user.id
      object.user_2 
    elsif object.user_2_id == current_user.id
      object.user_1
    else
      nil
    end
  end

  def last_read_at
    if object.user_1_id == current_user.id
      object.user_1_last_read_at 
    elsif object.user_2_id == current_user.id
      object.user_2_last_read_at 
    else
      nil
    end
  end

  def name
    if object.user_1_id == current_user.id
      object.user_2.nickname || object.user_2.masked_email 
    elsif object.user_2_id == current_user.id
      object.user_1.nickname || object.user_1.masked_email
    else
      (object.user_2.nickname || object.user_2.masked_email) + ' - ' + (object.user_1.nickname || object.user_1.masked_email)
    end
  end

  def others_last_read_at
    if object.user_1_id != current_user.id
      object.user_1_last_read_at 
    elsif object.user_2_id != current_user.id
      object.user_2_last_read_at 
    else
      nil
    end
  end

  # def messages
  #   @messages ||= object.get_last_messages(object.max_last_read_date(scope.current_user))
  #   @messages
  # end

  def unread_messages_count
    object.get_last_messages(object.last_read_date(current_user)).length
  end

  def total_messages_count
    object.chat_messages.length
  end

  def last_message_sent_at
    object.chat_messages.first.created_at if object.chat_messages.length > 0
  end
end
