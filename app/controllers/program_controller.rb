class ProgramController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, :except => %w{ index show home account reserve destroy }.map(&:to_sym)
  before_filter :authenticate_valid!
  before_filter :load_object,         :only => %w{ show new edit update destroy flag}.map(&:to_sym)
  before_filter :load_collection,     :only => %w{ index manage }.map(&:to_sym)
  
  helper_method :sort_field, :sort_direction
  
  uses_tiny_mce :options => { 
                              :theme => "advanced",
                              :theme_advanced_buttons3 => "pasteword, fullscreen, fontsizeselect, separator, tablecontrols",
                              :plugins => %w{ fullscreen paste spellchecker table }
                            }
  
  def home
    render 'program/home'
  end
  
  def index
    render "program/#{@_class.tableize}/index"
  end
  
  def show
    render "program/#{@_class.tableize}/show"
  end
  
  def new
    render "program/#{@_class.tableize}/new"
  end
  
  def edit
    render "program/#{@_class.tableize}/edit", :layout => 'admin'
  end
  
  def update
    @object.update_attributes(params[@_class.underscore.to_sym])
    flash[:notice] = "#{@_class.titleize} Updated"
    redirect_to object_edit_path(@_class, @object)
    
    # "program/#{@_class.tableize}/edit", :layout => 'admin'
  end
  
  def create
    _class = params[:_class]
    @object = _class.classify.constantize.new(params[_class.underscore.to_sym])
    @object.save!
    redirect_to object_manage_path(_class)
  end
  
  def destroy
    authenticate_admin! unless @_class =~ Regexp.new("reservation", true)
    @object.destroy
    if @_class =~ Regexp.new("reservation", true)
      flash[:notice] = "Reservation has been canceled"
      redirect_to object_index_path(@_class)
    else
      redirect_to object_manage_path(@_class)  
    end
  end
  # 
  # def create_embedded
  #   _parent = params[:_parent_class].classify.constantize
  #   # @object = _parent.method(params[:])
  #   
  # end
  # 
  # def update_embedded
  #   
  # end
  
  
  def manage
    render "program/#{@_class.tableize}/manage", :layout => 'admin'
  end
  
  # MISC. 
  
  def admin
    
  end
  
  def reserve
    message = {}
    if current_user.active?
      @reservation = Reservation.new(params[:reservation])
      @bike = Bike.find(@reservation.bike._id)
      if @bike.timeslots.where(:date => @reservation.date).and(:time.in => (@reservation.start..@reservation.stop).to_a).any?
        message[:notice] = "There was an error with your request"
      elsif current_user.reservations.any_of({:date.gt => CbTime.today}, {:date => CbTime.today, :stop.gte => (Time.zone.now.hour * 2)}).none?
        day_offset = params[:day_offset].to_i
        date = CbTime.today + day_offset.days
        @reservation.date = date
        @reservation.user_id = current_user._id
        if @reservation.save! && @bike.reserve(@reservation)
          message[:notice] = "Your reservation was successful"
          confirmation = Notifier.reservation_confirmation(@reservation)
          confirmation.deliver
          if @reservation.start <= (Time.zone.now.hour * 2 + (Time.zone.now.min >= 30 ? 1 : 0) + 4) 
            Notifier.send_unlock_code(@reservation).deliver
            @reservation.update_attribute(:reminder_sent_at, Time.zone.now)
          end
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
  
  def flag
    @object.update_attribute(:flagged, !@object.flagged)
    redirect_to object_edit_path(@_class, @object)
  end
  
  def create_admin
    @object = User.find(params[:_id])
    @object.update_attribute(:admin, true)
    redirect_to object_edit_path("users", @object)
  end
  
  def activate_account
    @object = User.find(params[:_id])
    @object.membership.activate
    redirect_to object_edit_path("users", @object)
  end
  
  def account
    render 'program/account'
  end
  
  def regenerate_combination
    @object = UnlockCode.find(params[:_id])
    @object.update_attribute(:combination, UnlockCode.generate_combination)
  end
  
  def open_ticket
    message = {}
    bike = Bike.find(params[:ticket][:bike_id])
    user = current_user
    if user.admin? || bike.reservations.today.collect(&:user_id).include?(user._id) 
      bike.reservations.where(:date.gte => CbTime.today).delete_all
      bike.tickets.create(params[:ticket].merge(:user_id => user._id))
      bike.update_attribute(:_status, "maintenance")
      message[:notice]  = "This bike has been flagged for repair"
      # Notice
    else
      message[:notice] = "There was an error"
    end
    redirect_to (object_index_path("reservations"), message)
  end
  
  def close_ticket
    message = {}
    ticket = Ticket.find(params[:id])
    bike = ticket.bike
    bike.update_attribute(:_status, "operational")
    ticket.update_attributes(params[:ticket].merge(:_status => "closed"))
    message[:notice] = "Ticket Closed"
    redirect_to (object_edit_path("ticket", ticket), message)
  end
  
  
  private
  def load_object
    _id     = params[:_id]
    @_class  = params[:_class]
    object_class = @_class.classify.constantize
    @object ||= _id.nil? ? object_class.new : object_class.find(params[:_id])
  end
  
  def load_collection
    @_class = params[:_class]
    # @objects = @_class.classify.constantize.all.all.sort( sort_direction, sort_field).retrieve(current_user)
    @objects = @_class.classify.constantize.sort_collection( sort_direction, sort_field).retrieve(current_user)
  end
  
  def sort_field
    params[:_class].classify.constantize.fields.include?( params[:sort_field] )? params[:sort_field] : nil
  end  
    
  def sort_direction
    %w{asc desc}.include?( params[:sort_direction]) ? params[:sort_direction] : "desc"
  end
  
end
