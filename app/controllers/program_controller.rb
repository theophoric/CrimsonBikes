class ProgramController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :home, :account, :reserve]
  layout 'admin', :except => [:index, :show, :home]

  
  def home
    render 'program/home', :layout => 'application'
  end
  
  def index
    _class = params[:_class] || "Bike"
    @objects = eval(_class.titleize.singularize).all
    render "program/#{_class.tableize}/index", :layout => 'application'
  end
  
  def show
    _class = params[:_class]
    _id = params[:_id]
    @object = eval(_class.titleize.singularize).find(_id)
    render "program/#{_class.tableize}/show", :layout => 'application'
  end
  
  def new
    _class = params[:_class]
    @object = eval(_class.titleize.singularize).new
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
    @object = _class.classify.constantize.new(params[_class.underscore])
    @object.save!
    redirect_to object_manage_path(_class, @object)
  end
  
  def create_embedded
    _parent = params[:_parent_class].classify.constantize
    # @object = _parent.method(params[:])
    
  end
  
  def update_embedded
    
  end
  
  def manage
    _class = params[:_class]
    @objects = eval(_class.titleize.singularize).page params[:page]
    render "program/#{_class.tableize}/manage"
  end
  
  def admin
    
  end
  
  def reserve
    @reservation = Reservation.new(params[:reservation])
    day_offset = params[:day_offset].to_i
    
    date = Time.now.midnight + @reservation.start.hours / 2.0 + day_offset.days
    @reservation.date = date
    @reservation.user_id = current_user._id    
    @reservation.save

    @bike = Bike.find(@reservation.bike._id)
    @bike.reserve(@reservation)
    flash[:notice] = "Reservation Successful"
    redirect_to object_index_path("bikes")
  end
  
  def account
    
  end
  
  
end
