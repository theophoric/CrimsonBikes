class Reservation
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :bike
  
  scope :today, where(:date => Date.today)
  scope :tomorrow, where(:date => Date.tomorrow)
  
  field :date,   :type => Date, :default => (Date.today)
  field :start,  :type => Integer
  field :stop,   :type => Integer
end
