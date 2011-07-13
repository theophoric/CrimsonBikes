class ProgramController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, :except => [:index, :show, :home, :account, :reserve, :destroy]
  
  
  uses_tiny_mce :options => { 
                              :theme => "advanced",
                              :theme_advanced_buttons3 => "pasteword, fullscreen, fontsizeselect, separator, tablecontrols",
                              :plugins => %w{ fullscreen paste spellchecker table }
                            }
  
  def home
    render 'program/home'
  end
  
  def index
    _class = params[:_class] || "Bike"
    @objects = _class.classify.constantize.retrieve current_user
    render "program/#{_class.tableize}/index"
  end
  
  def show
    _class = params[:_class]
    _id = params[:_id]
    @object = _class.classify.constantize.find(_id)
    render "program/#{_class.tableize}/show"
  end
  
  def new
    _class = params[:_class]
    @object = _class.classify.constantize.new
    render "program/#{_class.tableize}/new"
  end
  
  def edit
    _class = params[:_class]
    _id = params[:_id]
    @object = _class.classify.constantize.find(_id)
    render "program/#{_class.tableize}/edit", :layout => 'admin'
  end
  
  def update
    _class = params[:_class]
    _id = params[:_id]
    @object = _class.classify.constantize.find(_id)
    @object.update_attributes(params[_class.underscore])
    flash[:notice] = "#{_class.titleize} Updated"
    render "program/#{_class.tableize}/edit", :layout => 'admin'
  end
  
  def create
    _class = params[:_class]
    @object = _class.classify.constantize.new(params[_class.underscore.to_sym])
    @object.save!
    redirect_to object_manage_path(_class)
  end
  
  def destroy
    _class = params[:_class]
    authenticate_admin! unless _class[Regexp.new("reservation", true)]
    @object = _class.classify.constantize.find(params[:_id])
    @object.destroy
    if _class[Regexp.new("reservation", true)]
      flash[:notice] = "#{_class.titleize} destroyed"
      redirect_to object_index_path(_class)
    else
      redirect_to object_manage_path(_class)  
    end
    
  end
  
  def create_embedded
    _parent = params[:_parent_class].classify.constantize
    # @object = _parent.method(params[:])
    
  end
  
  def update_embedded
    
  end
  
  def manage
    _class = params[:_class]
    @objects = _class.classify.constantize.page params[:page]
    render "program/#{_class.tableize}/manage", :layout => 'admin'
  end
  
  def admin
    
  end
  
  def reserve
    message = {}
    if current_user.processed
      if current_user.reservations.future.none? 
        @reservation = Reservation.new(params[:reservation])
        day_offset = params[:day_offset].to_i
        date = Date.today.midnight + day_offset.days
        @reservation.date = date
        @reservation.user_id = current_user._id    
        @bike = Bike.find(@reservation.bike._id)    
        if @reservation.save && @bike.reserve(@reservation)
          message[:notice] = "Your reservation was successful"
          confirmation = Notifier.reservation_confirmation(@reservation)
          confirmation.deliver
        else
          message[:notice] = "There was an error in your request"
        end
      else
        message[:notice] = "You can only have one active reservation at a time with your current membership."
      end
    else
      message[:notice] = "You must wait until your membership payment has been processed until you can reserve bikes."
    end
    redirect_to (object_index_path("bikes"), message)
  end
  
  def account
    render 'program/account'
  end
  
  def regenerate_combination
    @object = UnlockCode.find(params[:id])
    @object.update_attribute(:combination, UnlockCode.generate_combination)
  end
  
end
