class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  def authenticate_admin!
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
  
end
