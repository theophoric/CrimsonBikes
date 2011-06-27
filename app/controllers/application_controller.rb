class ApplicationController < ActionController::Base
  
  helper_method :admin_user?, :current_usertype
  protect_from_forgery
  
  
  def authenticate_admin!
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
  
  def admin_user?
    user_signed_in? && current_user.admin?
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
end
