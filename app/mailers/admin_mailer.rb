class AdminMailer < ActionMailer::Base
  def user_list(users)
    attachments['usuarios.csv'] = { mime_type: 'text/csv', content: users.to_csv }

    mail_from = ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
    mail(from: "Roupa Livre <#{mail_from}>", to: ENV['ADMIN_MAIL'], subject: "Lista de Usuarios")
  end

  def apparel_list(apparels)
    attachments['pecas.csv'] = { mime_type: 'text/csv', content: apparels.to_csv }

    mail_from = ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
    mail(from: "Roupa Livre <#{mail_from}>", to: ENV['ADMIN_MAIL'], subject: "Lista de Peças")
  end

  def stats(stats_object)
    @stats_object = stats_object

    mail_from = ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
    mail(from: "Roupa Livre <#{mail_from}>", to: ENV['ADMIN_MAIL'], subject: "Estatisticas")
  end
end