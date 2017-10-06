require 'fcm'
require 'grocer'

class PushSender
  include Singleton

  def send_android_push(registration_ids, title, message, image, push_collapse_key, extraData)
    sender = FCM.new(ENV["FCM_SENDER_KEY"])

    options = { data: extraData, collapse_key: push_collapse_key}
    options[:data][:title] = title
    options[:data][:message] = message
    options[:data][:image] = image ? image : 'default_push_image'
    options[:icon] = 'default_push_icon'

    response = sender.send(registration_ids, options)
  end

  def send_ios_push(registration_ids, title, message, image, push_collapse_key, extraData)
    if ios_gateway
      if ios_passphrase
        sender = Grocer.pusher(certificate: ios_certificate, gateway: ios_gateway, passphrase: ios_passphrase)
      else
        sender = Grocer.pusher(certificate: ios_certificate, gateway: ios_gateway)
      end
    elsif ios_passphrase
      sender = Grocer.pusher(certificate: ios_certificate, passphrase: ios_passphrase)
    else
      sender = Grocer.pusher(certificate: ios_certificate)
    end

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

  def ios_gateway
    ENV['APN_GATEWAY']
  end

  def ios_certificate
    ENV['APN_CERTIFICATE'] ? StringIO.new(ENV['APN_CERTIFICATE']) : ios_cert_path
  end

  def ios_cert_path
    path = "#{Rails.root}/config/apn_credentials/"
    path += Rails.env.production? ? "production-cert.pem" : (ENV["APN_CERTIFICATE_FILE"] ? ENV["APN_CERTIFICATE_FILE"] : "development-cert.pem")
    return path
  end

  private
    def ios_passphrase
      ENV['APN_PASSPHRASE']
    end
end
