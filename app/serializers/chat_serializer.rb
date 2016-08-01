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
  attributes :id, :user_1_id, :user_2_id, :user_1_accepted, :user_2_accepted, :name, :last_read_at
  attributes :other_user, :others_last_read_at
  attributes :other_user_apparel_images, :owned_apparel_images
  attributes :unread_messages_count, :total_messages_count, :last_message_sent

  # def initialize(object, options = {})
  #   super(object, options = {})

  #   @current_user_last_read = nil
  #   @other_last_read = nil
  #   @other_user = nil
  # end

  def init_users
    @current_user_last_read = nil
    @other_last_read = nil
    @other_user = nil

    # if current_user
      if object.user_1_id == current_user.id
        @current_user_last_read = object.user_1_last_read_at
        @other_last_read = object.user_2_last_read_at
        @other_user = object.user_2
      elsif object.user_2_id == current_user.id
        @current_user_last_read = object.user_2_last_read_at
        @other_last_read = object.user_1_last_read_at
        @other_user = object.user_1
      end      
    # end
  end

  def get_other_user
    init_users
    @other_user
  end

  def get_current_user_last_read
    init_users
    @current_user_last_read
  end

  def get_other_last_read
    init_users
    @other_last_read
  end

  def other_user
    @other_user || get_other_user
  end

  def last_read_at
    @current_user_last_read || get_current_user_last_read
  end

  def others_last_read_at
    @other_last_read || get_other_last_read
  end

  def name
    if other_user
      @other_user.public_name
    else
      object.user_2.public_name + ' - ' + object.user_1.public_name
    end
  end

  def other_user_apparel_images
    object.user_apparels(other_user).map { |apparel| apparel.apparel_images.first  } if @other_user
  end

  def owned_apparel_images
    object.user_apparels(current_user).map { |apparel| apparel.apparel_images.first  } if current_user
  end

  def unread_messages_count
    object.get_last_messages(object.last_read_date(current_user)).length
  end

  def total_messages_count
    object.chat_messages.length
  end

  def last_message_sent
    @last_message_sent ||= object.chat_messages.first
    @last_message_sent
  end
end
