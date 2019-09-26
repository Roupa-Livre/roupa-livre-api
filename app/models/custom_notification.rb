# == Schema Information
#
# Table name: custom_notifications
#
#  id           :integer          not null, primary key
#  push_title   :string           not null
#  push_message :string           not null
#  title        :string           not null
#  image_url    :string
#  body         :text
#  action_link  :string
#  action_title :string
#  sent_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CustomNotification < ActiveRecord::Base
  validates_presence_of :push_title, :push_message, :title

  def send_notification
    image = nil
    push_collapse_key = 'roupa_notification'
    extraData = { 
      title: self.title,
      image_url: self.image_url,
      action_link: self.action_link,
      action_title: self.action_title,
      body: self.body,
      type: 'custom' 
    }

    android_ids = Device.where(provider: 'android').map { |e| e.uid  }
    PushSender.instance.send_android_push(android_ids, self.push_title, self.push_message, image, push_collapse_key, extraData) if android_ids.length > 0

    ios_ids = Device.where(provider: 'ios').map { |e| e.uid  }
    PushSender.instance.send_ios_push(ios_ids, self.push_title, self.push_message, image, push_collapse_key, extraData) if ios_ids.length > 0

    self.sent_at = Time.now
    self.save
  end
end
