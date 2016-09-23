require 'fcm'
require 'grocer'

class PushSender
  include Singleton

  def send_android_push(registration_ids, title, message, image, push_collapse_key, extraData)
    sender = FCM.new(ENV["FCM_SENDER_KEY"])

    options = { data: extraData, collapse_key: push_collapse_key}
    options[:data][:title] = title
    options[:data][:message] = message
    options[:data][:image] = image

    response = sender.send(registration_ids, options)
  end

  def send_ios_push(registration_ids, title, message, image, push_collapse_key, extraData)
    sender = Grocer.pusher(certificate: ios_cert_path)

    registration_ids.each do |registration_id|
      notification = Grocer::Notification.new(
        device_token:      registration_id,
        alert:             { title: title, body: message},
        badge:             1,
        custom:             extraData
      )
      sender.push(notification)
    end
  end

  protected
    def ios_cert_path
      path = "#{Rails.root}/config/apn_credentials/"
      path += Rails.env.production? ? "production-cert.pem" : "development-cert.pem"
      return path    
    end
end