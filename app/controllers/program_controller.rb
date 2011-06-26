class ProgramController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :home, :account, :reserve, :destroy]
  layout 'admin', :except => [:index, :show, :home]

  
  def home
    render 'program/home', :layout => 'application'
  end
  
  def index
    _class = params[:_class] || "Bike"
    @objects = _class.classify.constantize.retrieve current_user
    render "program/#{_class.tableize}/index", :layout => 'application'
  end
  
  def show
    _class = params[:_class]
    _id = params[:_id]
    @object = _class.classify.constantize.find(_id)
    render "program/#{_class.tableize}/show", :layout => 'application'
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
    render "program/#{_class.tableize}/edit"
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
    @object = _class.classify.constantize.find(params[:id])
    @object.destroy
    if _class[Regexp.new("reservation", true)]
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
    render "program/#{_class.tableize}/manage"
  end
  
  def admin
    
  end
  
  def reserve
    message = {}
    @reservation = Reservation.new(params[:reservation])
    day_offset = params[:day_offset].to_i
    
    date = Time.now.midnight + day_offset.days
    @reservation.date = date
    @reservation.user_id = current_user._id    
    @bike = Bike.find(@reservation.bike._id)    
    if @reservation.save && @bike.reserve(@reservation)
      message[:notice] = "Your reservation was successful"
    else
      message[:error] = "There was an error in your request"
    end

    redirect_to (object_index_path("bikes"), message)
  end
  
  def account
    
  end
  
  
end
