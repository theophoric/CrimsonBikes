class ApplicationController < ActionController::Base
  helper_method :admin_user?
  before_filter :authenticate_user!
  protect_from_forgery
  
  
  def authenticate_admin!
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
  
  def admin_user?
    user_signed_in && current_user.admin?
  end
  
end
