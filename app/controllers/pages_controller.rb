class PagesController < ApplicationController
  before_filter {if user_signed_in? then  redirect_to (current_user.processed ? object_index_path("bikes") : account_path) end}
  def welcome
    
  end
  
  def about

  end
  
  def contact
    
  end
end
