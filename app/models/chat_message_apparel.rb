# == Schema Information
#
# Table name: chat_message_apparels
#
#  id              :integer          not null, primary key
#  chat_message_id :integer
#  apparel_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ChatMessageApparel < ActiveRecord::Base
  belongs_to :chat_message
  belongs_to :apparel
end
