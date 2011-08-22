task :cron => :environment do
  if Time.zone.now.hour == 0
    UnlockCode.generate
  end
  reservations = Reservation.today.unreminded.where(:start.lte => (Time.now.hour * 2 + (Time.now.min >= 30 ? 1 : 0) + 4))
  if reservations.any?
    reservations.each do |r|
      Notifier.send_unlock_code(r).deliver
      r.update_attribute(:reminder_sent, true)
    end
  end
end