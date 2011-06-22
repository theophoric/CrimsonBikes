class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  belongs_to :bike
  
  scope :today, where(:date => Date.today)
  scope :tomorrow, where(:date => Date.tomorrow)
  
  field :date,   :type => Time, :default => (Time.now)
  field :start,  :type => Integer
  field :stop,   :type => Integer
end
