task :cron => :environment do
  puts "Running scheduled cron tasks..."
  if Time.zone.now.hour == 11
    UnlockCode.generate
  end
  reservations = Reservation.today.unreminded.where(:start.lte => (Time.now.hour * 2 + (Time.now.min >= 30 ? 1 : 0) + 4))
  puts reservations.count
  if reservations.any?
    reservations.each do |reservation|
      puts "sending reminder to #{reservation.user_id}"
      Notifier.send_unlock_code(reservation).deliver
      reservation.update_attribute(:reminder_sent_at, Time.zone.now)
    end
  end
end