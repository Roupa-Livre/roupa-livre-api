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

class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :message, :created_at, :type

  class CustomApparelSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :title, :main_image_url

    def main_image_url
      object.main_image ? object.main_image.file_url : nil
    end
  end

  has_many :apparels, serializer: CustomApparelSerializer do
    object.apparels
  end
end
