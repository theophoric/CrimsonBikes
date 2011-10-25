class PagesController < ApplicationController
  before_filter {if user_signed_in? then  redirect_to (current_user.active? ? object_index_path("bikes") : account_path) end}
  def welcome
    
  end
  
  def about
    @pages = StaticPage.all
  end
  
  def contact
    
  end
  
  def blog
    
  end
  
  def how_it_works
    
  end
  
  def locations
    @locations = Location.all
  end
  
end
