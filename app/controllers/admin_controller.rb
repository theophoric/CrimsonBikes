class AdminController < ApplicationController
  before_filter :authenticate_admin!
  
  def home
    
  end
  

end
