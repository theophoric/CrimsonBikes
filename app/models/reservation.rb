class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  belongs_to :bike
  
  scope :today, where(:date => Date.today)
  scope :tomorrow, where(:date => Date.tomorrow)
  
  field :date,   :type => Time, :default => (Time.now)
  field :start,  :type => Integer, :default => (Time.now.hour < 6 ? 12 : (Time.now.hour * 2))
  field :stop,   :type => Integer, :default => (Time.now.hour < 6 ? 14 : (Time.now.hour * 2 + 2))
  
  validates_presence_of :date, :start, :stop
  validates_inclusion_of :start, :in => 0..47
  validates_inclusion_of :stop, :in => 1..48
  
  before_destroy :clear_timeslots
  
  def clear_timeslots
    bike.timeslots.where(:reservation_id => _id).delete_all
  end
  
  def start_time
    date + start.hours
  end
  
  def end_time
    date + stop.hours
  end
  
  def duration
    stop - start
  end
  
  def start= new_start
    if start == new_start
      return self
    else
      update_attribute(:start, new_start)
    end
  end
  
  def stop= new_stop
    if stop == new_stop
      return self
    else
      update_attribute(:stop, new_stop)
    end
  end
  
end
