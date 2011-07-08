task :cron => :environment do
  reservations = Reservation.today.unreminded.where(:start.lte => (Time.now.hour * 2 + (Time.now.min >= 30 ? 1 : 0) + 4))
  if reservations.any?
    reservations.each{|r| Notifier.send_unlock_code(r).deliver}
  end
end