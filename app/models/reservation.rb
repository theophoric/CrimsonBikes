class Reservation
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :bike
  
  field :start,  :type => Integer
  field :stop,   :type => Integer
end
