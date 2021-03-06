task :cron => :environment do
  puts "Running scheduled cron tasks..."
  if Time.zone.now.hour == 11
    UnlockCode.generate
  end
  if Time.zone.now.hour == 1
    Notifier.send_admin_unlock.deliver
  end
  reservations = Reservation.today.unreminded.where(:start.lte => (Time.zone.now.hour * 2 + (Time.zone.now.min >= 30 ? 1 : 0) + 4))
  if reservations.any?
    reservations.each do |reservation|
      puts "sending reminder to #{reservation.user_id}"
      Notifier.send_unlock_code(reservation).deliver
      reservation.update_attribute(:reminder_sent_at, Time.zone.now)
    end
  end
end