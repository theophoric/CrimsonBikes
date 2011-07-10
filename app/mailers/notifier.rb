class Notifier < ActionMailer::Base
  default :from => "reservations@crimsonbikes.org"
  
  def send_unlock_code( reservation )
    @reservation = reservation
    @user = reservation.user
    @unlock_code = UnlockCode.get_current
    mail(
      :to       => @user.email,
      :subject  => "CrimsonBikes Reservation Reminder and Unlock Code"
    )
  end
end
