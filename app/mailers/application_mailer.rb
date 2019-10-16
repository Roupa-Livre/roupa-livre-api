class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
  layout 'mailer'
end
