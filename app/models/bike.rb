class Bike
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  
  include Sortable
  
  mount_uploader :image, ImageUploader
  
  belongs_to :location
  has_many :reservations
  has_many :tickets
  
  embeds_many :timeslots
  embeds_many :notes, :as => :notable
  embeds_many :comments, :as => :commentable
  # embeds_many :images, :as => :imageable
  embeds_one :description, :as => :describeable
  
  scope :operational, where(:_status => "operational")
  default_scope desc(:name)
  
  field :name, :default => "New Bike"
  field :_model, :default => "road"
  field :_status, :default => "standby"
  field :_identifier
  field :_size, :default => "medium"
  
  # index :_identifier, :unique => true
  index :name
  
  validates_uniqueness_of :_identifier
  validates_inclusion_of :_status, :in => %w{ standby operational maintenance }
  validates_inclusion_of :_model, :in => %w{ mountain street }
  validates_inclusion_of :_size, :in => %w{ small medium large }
  
  def reserve(reservation)
    #unless timeslot.where(:time.within => [start..stop], :date => date).any?
    if timeslots.where(:date => reservation.date).and(:time.in => (reservation.start..reservation.stop).to_a).any?
      reservation.destroy
      return false
    end
    for time in ([(reservation.start - 1), 0].max..[(reservation.stop + 1), 96].min).to_a do
      self.timeslots.create(:time => time, :date => reservation.date, :reservation_id => reservation.id)
    end
    reservations << reservation
    save!
    return true
  end
  
  def filter_data
    data = {:class => []}
    c_array = timeslots.today.collect{|t| "timeslot-#{t.time}"} + timeslots.tomorrow.collect{|t| "timeslot-#{t.time + 48}"}
    data[:location] = location.name.gsub(" ", "_").downcase if location
    data[:model]  = _model
    data[:class]  = c_array.join(" ")
    data[:size]   = _size
    # description.attributes.each do |key, value|
    #   data[key.to_sym] = value
    # end
    return data.to_options
  end
  
  class << self
    def retrieve user = OpenStruct.new(:admin? => false)
      user.admin? ? all : operational
    end
    
    def search query = nil
      if query
        regex_query = Regexp.new(query, true)
        any_of({:name => regex_query}, {:_identifier => regex_query})
      else
        all
      end
    end
  end
  
end

class Description
  include Mongoid::Document
  
  embedded_in :describeable, :polymorphic => true
  
end

class Timeslot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :reservation
  
  embedded_in :bike
  
  scope :today, where(:date => Date.today.midnight)
  scope :tomorrow, where(:date => (Date.today.midnight + 1.day))
  scope :active, where(:date.in => [Date.today, Date.tomorrow])
  
  default_scope asc(:time)
  
  field :date
  field :time
  
  validates_presence_of :date, :time
  # validates_uniqueness_of :time
  
  index :date
  
end