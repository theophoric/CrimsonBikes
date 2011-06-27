class Bike
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  
  mount_uploader :image, ImageUploader
  
  belongs_to :location
  has_many :reservations
  has_many :tickets
  
  embeds_many :timeslots
  embeds_many :notes, :as => :notable
  embeds_many :comments, :as => :commentable
  # embeds_many :images, :as => :imageable
  embeds_one :description, :as => :describeable
  
  scope :opperational, where(:_status => "opperational")
  default_scope asc(:_identifier)
  
  field :name, :default => "New Bike"
  field :_model, :default => "road"
  field :_status, :default => "standby"
  field :_identifier
  field :_size, :default => "medium"
  
  index :_identifier, :unique => true
  
  validates_uniqueness_of :_identifier
  validates_inclusion_of :_status, :in => %w{ standby operational maintenance }
  validates_inclusion_of :_model, :in => %w{ mountain road }
  validates_inclusion_of :_size, :in => %w{ small medium large }
  
  def self.retrieve user
    user.admin? ? all : opperational
  end
  
  def reserve(reservation)
    #unless timeslot.where(:time.within => [start..stop], :date => date).any?
    
    for time in ([(reservation.start - 1), 0].max..[(reservation.stop + 1), 96].min).to_a do
      self.timeslots.create(:time => time, :date => reservation.date, :reservation_id => reservation.id)
    end
    reservations << reservation
    save!
  end
  
  def filter_data
    data = {:class => []}
    c_array = timeslots.today.collect{|t| "timeslot-#{t.time}"} + timeslots.tomorrow.collect{|t| "timeslot-#{t.time + 48}"}
    data[:location] = location.name.gsub(" ", "_").downcase if location
    data[:model] = _model
    data[:class] = c_array.join(" ")
    # description.attributes.each do |key, value|
    #   data[key.to_sym] = value
    # end
    return data.to_options
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