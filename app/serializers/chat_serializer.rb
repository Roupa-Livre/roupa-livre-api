class ChatSerializer < ActiveModel::Serializer
  attributes :id, :user_1_accepted, :user_2_accepted, :unred_messages_count, :last_message_sent_at

  has_many :user_1
  has_many :user_2

  def attributes(*args)
    data = super
    data[:messages] = messages if @options[:include_messages].present? && @options[:include_messages]
    data
  end

  def messages
    object.chat_messages.where('created_at > ?', @options[:last_read])
  end

  def unred_messages_count
    if @options[:unred_count].present?
      object.chat_messages.where('created_at > ?', @options[:last_read]).length
    else
      0
    end
  end

  def last_message_sent_at
    object.chat_messages.first.created_at if object.chat_messages.length > 0
  end
end
