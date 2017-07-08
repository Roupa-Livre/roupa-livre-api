class ReportWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform()
    puts "Sidekiq for ReportWorker RUNNING"
    ReportWorker.perform_in(1.day)

    do_perform
    puts "Sidekiq for ReportWorker FINISHED"
  end

  def do_perform
    Time.use_zone('Brasilia') do
      currentTime = Time.zone.now
      AdminMailer.stats(ReportWorker.all_stats).deliver
      if currentTime.day == 10
        AdminMailer.user_list(User.all).deliver
        AdminMailer.apparel_list(Apparel.all).deliver
      end
    end
  end

  def self.all_stats
    all = {}
    all[:yesterday] = grouped_stats(Time.new - 1.day)
    all[:last_two_days] = grouped_stats(Time.new - 2.days)
    all[:last_week] = grouped_stats(Time.new - 1.week)
    all[:last_month] = grouped_stats(Time.new - 1.month)
    all[:before_last_month] = grouped_stats(nil, Time.new - 1.month)
    all[:overall] = grouped_stats
    all
  end

  def self.grouped_stats(start_date = nil, end_date = nil)
    results = {}
    results[:date] = start_date if start_date
    results[:end_date] = end_date if end_date
    results[:apparels] = stats(Apparel, start_date, end_date)
    results[:liked_apparel_ratings] = stats(ApparelRating.where(liked: true), start_date, end_date)
    results[:not_liked_apparel_ratings] = stats(ApparelRating.where.not(liked: true), start_date, end_date)
    results[:blocked_users] = stats(BlockedUser, start_date, end_date)
    results[:chats] = stats(Chat, start_date, end_date)
    results[:chat_messages] = stats(ChatMessage, start_date, end_date)
    results[:user] = stats(User, start_date, end_date)
    results
  end

  def self.stats(resource, start_date, end_date)
    if start_date && end_date
      resource.where('created_at > ? && created_at <= ?', start_date, end_date).count
    elsif start_date
      resource.where('created_at > ?', start_date).count
    elsif end_date
      resource.where('created_at <= ?', end_date).count
    else
      resource.all.count
    end
  end

  def self.start
    set = Sidekiq::ScheduledSet.new
    jobs = set.select {|job| job.klass == 'ReportWorker' }
    if jobs.length == 0
      Time.use_zone('Brasilia') do
        currentTime = Time.zone.now

        scheduleTime = Time.zone.local(currentTime.year,currentTime.month, currentTime.day, 10, 0, 0)
        if scheduleTime <= currentTime
          scheduleTime = scheduleTime + 1.day
        end

        ReportWorker.perform_at(scheduleTime)
      end
    end
  end

end
