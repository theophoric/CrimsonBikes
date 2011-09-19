class ApplicationController < ActionController::Base
  
  helper_method :admin_user?, :current_usertype, :current_time, :current_date
  protect_from_forgery
  
  
  def authenticate_admin!
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
  
  def admin_user?
    user_signed_in? && current_user.admin?
  end
  
  def authenticate_valid!
    if user_signed_in? && current_user.flagged
      flash[:notice] = "ERROR:  Your account has been frozeb by a CrimsonBikes administrator.  If uou believe this message to be in error, please contact info@crimsonbikes.org to resolve the issue."
      redirect_to( destroy_user_session_path)
    end
  end
  
  def current_usertype
    if user_signed_in?
      if current_user.admin?
        "admin"
      else
        "member"
      end
    else
      "guest"
    end
  end
  
  def current_time
    Time.zone.now
  end
  
  def current_date
    current_time.to_date
  end
  

  
end
