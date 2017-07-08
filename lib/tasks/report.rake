namespace :report do
  desc "Stats mail sender"
  task stats: :environment do
    AdminMailer.stats(ReportWorker.all_stats).deliver
  end

  task stats_console: :environment do
    puts ReportWorker.all_stats.to_json
  end

  task users: :environment do
    AdminMailer.user_list(User.all).deliver
  end

  task apparels: :environment do
    AdminMailer.apparel_list(Apparel.all).deliver
  end

end
