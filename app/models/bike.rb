class Bike
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  
  mount_uploader :image, ImageUploader
  
  belongs_to :location
  
  embeds_many :timeslots
  embeds_many :notes, :as => :notable
  # embeds_many :images, :as => :imageable
  embeds_one :description, :as => :describeable
  
  default_scope asc(:_identifier)
  
  field :name
  field :_status
  field :_identifier
  
  index :_identifier, :unique => true
  
  # validates_uniqueness_of :_identifier
  
  def reserve(reservation)
    for time in (reservation.start..reservation.end) do
      timeslots << new_timeslot(:time => time, :date => reservation.date)
    end
    reservations << reservation
    save!
  end
  
  def filter_data
    data = {}
    for item in timeslots.today do
      data[:timeslot_today] << "timeslot-#{item.time}, "
    end
    for item in timeslots.tomorrow do
      data[:timeslot_today] << "timeslot-#{item.time}, "
    end
    data[:location] = location.name.gsub(" ", "_").downcase if location
    description.attributes.each do |key, value|
      data[key.to_sym] = value
    end
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
  
  embedded_in :bike
  
  scope :today, where(:date => Date.today)
  scope :tomorrow, where(:date => Date.tomorrow)
  scope :active, where(:date.in => [Date.today, Date.tomorrow])
  
  default_scope asc(:time)
  
  field :date, :type => Date, :default => (Date.today)
  field :time
  
  validates_presence_of :date, :time
  validates_uniqueness_of :time, :scope => :date
  
  index :date
  
end