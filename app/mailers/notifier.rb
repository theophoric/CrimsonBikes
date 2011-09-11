class Notifier < ActionMailer::Base
  default :from => "reservations@crimsonbikes.org"
  
  
  def send_unlock_code( reservation )
    @reservation = reservation
    @bike = reservation.bike
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
  
  def send_notice( user, notice_options = {}, notice_body = "" )
    @user = user
    @text = notice_body
    mail(notice_options)
  end
  
  def send_admin_unlock
    @unlock_code = UnlockCode.get_current
    mail(
      :to       => "admin@crimsonbikes.org", 
      :subject  => "Current Crimsonbikes Unlock Code"
    )
  end
  
  def send_feedback( email = "anonymous@feedback.message", feedback_body = "")
    @body = feedback_body
    mail(
      :to     => "info@crimsonbikes.org",
      :subject=> "CrimsonBikes Website Feedback"
    )
  end
  
end
