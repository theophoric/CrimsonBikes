class ProgramController < ApplicationController
  
  before_filter :authenticate_admin!, :except => [:index, :show, :home]
  layout 'admin', :except => [:index, :show, :home]

  
  def home
    render 'program/home', :layout => 'application'
  end
  
  def index
    _class = params[:_class]
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
    @object = eval(_class.titleize.singularize).find(_id)
    render "program/#{_class.tableize}/edit"
  end
  
  def create
    _class = params[:_class]
    @object = eval(_class.titleize.singularize).new(params[_class.underscore])
    @object.save!
    redirect_to object_manage_path(_class, @object)
  end
  
  def manage
    _class = params[:_class]
    @objects = eval(_class.titleize.singularize).all
    render "program/#{_class.tableize}/manage"
  end
  
  def admin
    
  end
  
  
end
