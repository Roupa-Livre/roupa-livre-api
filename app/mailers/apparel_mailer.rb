class ApparelMailer < ActionMailer::Base
  def report(apparel_report_id)
    @apparel_report = ApparelReport.with_deleted.find(apparel_report_id)
    @apparel = @apparel_report.apparel

    mail_from = ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
    mail(from: "Roupa Livre <#{mail_from}>", to: ENV['ADMIN_MAIL'], subject: "Peça denunciada")
  end

  def stats(stats_object)
    @stats_object = stats_object

    mail_from = ENV['MAILER_FROM'] || 'kikecomp@gmail.com'
    mail(from: "Roupa Livre <#{mail_from}>", to: ENV['ADMIN_MAIL'], subject: "Estatisticas")
  end
end