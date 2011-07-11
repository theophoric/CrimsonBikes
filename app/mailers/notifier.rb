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
  
  def reservation_confirmation( reservation )
    @reservation = reservation
    @user = reservation.user
    @bike = reservation.bike
    mail(
      :to       => @user.email,
      :subject  => "CrimsonBikes Reservation Confirmation"
    )
  end
  
  def send_notice( notice_options = {}, notice_body = "", user = nil )
    @user = user
    @text = notice_body
    mail(notice_options)
  end
  
end
