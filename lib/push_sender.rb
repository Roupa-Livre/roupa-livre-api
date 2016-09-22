require 'fcm'

class PushSender
  include Singleton

  def fcm
    @fcm ||= FCM.new("AIzaSyAFj1JeQLV5pkjBdUaA4xKcsPHQZsUn7qg")
  end

  def send_android_push(registration_ids, title, message, image, push_collapse_key, extraData)
    options = { data: extraData, collapse_key: push_collapse_key}
    options[:data][:title] = title
    options[:data][:message] = message
    options[:data][:image] = image

    response = fcm.send(registration_ids, options)
  end
end