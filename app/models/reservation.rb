class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Searchable
  include Sortable
  
  belongs_to :user
  belongs_to :bike
  
  scope :today, where(:date => CbTime.today)
  scope :tomorrow, where(:date => CbTime.tomorrow)
  scope :future, where(:date.gte => CbTime.today)
  scope :past, where(:date.lt => CbTime.today)
  scope :unreminded, where(:reminder_sent_at => nil)
  # scope :future, where(:date)
  default_scope desc(:date, :start, :stop)
  
  field :date,   :type => Time
  field :start,  :type => Integer, :default => (Time.now.hour < 6 ? 12 : (Time.now.hour * 2))
  field :stop,   :type => Integer, :default => (Time.now.hour < 6 ? 14 : (Time.now.hour * 2 + 2))
  field :reminder_sent_at, :type => Time
  
  index :date
  index :start
  
  validates_presence_of :date, :start, :stop
  validates_inclusion_of :start, :in => 0..47
  validates_inclusion_of :stop, :in => 1..48
  
  before_destroy :clear_timeslots
  
  # CALLBACK METHODS
  

  
  def clear_timeslots
    bike.timeslots.where(:reservation_id => _id).delete_all
  end
  
  def date
    read_attribute("date")
  end
  
  # INSTANCE METHODS
  def expired?
    date < CbTime.today || (date == CbTime.today && stop < Time.zone.now.hour * 2)
  end
  
  def filter_data
    data = {:class => []}
    # c_array = timeslots.today.collect{|t| "timeslot-#{t.time}"} + timeslots.tomorrow.collect{|t| "timeslot-#{t.time + 48}"}
    time_now = Time.now
    if (date + stop.hours / 2) < time_now
      data[:time] = "past"
    elsif (date + start.hours / 2 - 2.hours) > time_now
      data[:time] = "future"
    else
      data[:time] = "current"
    end
    data[:location] = bike.location.name.gsub(" ", "_").downcase if bike && bike.location
    # data[:model] = _model
    # data[:class] = c_array.join(" ")
    # description.attributes.each do |key, value|
    #   data[key.to_sym] = value
    # end
    return data.to_options
  end
  
  def expand_time
    start_hr = (start / 2) % 12;
    start_min = start % 2 == 0 ? "00" : "30";
    start_offset = start < 24 ? " am" : " pm";
    stop_hr = (stop / 2) % 12;
    stop_min = stop % 2 == 0 ? "00" : "30";
    stop_offset = stop < 24 ? " am" : " pm";
    return "#{start_hr == 0 ? 12 : start_hr}:#{start_min} #{start_offset} - #{stop_hr == 0 ? 12 : stop_hr}:#{stop_min} #{stop_offset}"
  end
  
  def expand_date
    return "#{Date::ABBR_MONTHNAMES[date.month]} #{date.mday}"
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
  
  # CLASS METHODS
  class << self
    def retrieve user
      # user.reservations
      user.admin? ? all : where(:user_id => user._id)
    end
    
  end
end
