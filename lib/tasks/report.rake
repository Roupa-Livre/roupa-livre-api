namespace :report do
  desc "Stats mail sender"
  task stats: :environment do
    ApparelMailer.stats(all_stats).deliver
  end

  task stats_console: :environment do
    puts all_stats.to_json
  end

  def all_stats
    all = {}
    all[:yesterday] = grouped_stats(Time.new - 1.day)
    all[:two_days] = grouped_stats(Time.new - 2.days)
    all[:week] = grouped_stats(Time.new - 1.week)
    all[:month] = grouped_stats(Time.new - 1.month)
    all[:all] = grouped_stats(Time.new - 1.year, false)
    all
  end

  def grouped_stats(date, show_date = true)
    results = {}
    results[:date] = date if show_date
    results[:apparels] = stats(Apparel, date)
    results[:apparel_ratings] = stats(ApparelRating, date)
    results[:blocked_users] = stats(BlockedUser, date)
    results[:chats] = stats(Chat, date)
    results[:chat_messages] = stats(ChatMessage, date)
    results[:user] = stats(User, date)
    results
  end

  def stats(resource, date)
    resource.where('created_at > ?', date).count
  end

end
