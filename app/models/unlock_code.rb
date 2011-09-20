class UnlockCode
  include Mongoid::Document
  
  # limit collection to 10... ?
  
  include Searchable
  include Sortable
  
  scope :expired, where(:unlock_date.lt => Time.zone.now.utc.midnight)
  scope :future, where(:unlock_date.gt => Time.zone.now.utc.midnight)
  # default_scope where(:unlock_date.gt => (Time.zone.now.utc.midnight - 1.day)).desc(:unlock_date).limit(5)
  default_scope desc(:unlock_date)
  
  field :unlock_date
  field :combination
  
  index :unlock_date
  
  validates_presence_of :unlock_date, :combination
  validates_uniqueness_of :unlock_date
  validates_format_of :combination, :with => /[\d]{4}/
  
  def expired?
    unlock_date.to_date < Date.today
  end
  
  class << self
    def get_current date = Time.zone.now.utc.midnight
      date = date.utc.midnight
      generate unless where(:unlock_date => date).any?
      first(:conditions => {:unlock_date => date})
    end
  
    def generate num = 1
      members = UnlockCode.where(:unlock_date.gte => Time.zone.now.utc.midnight).desc(:unlock_date)
      date = members.any? ? (members.first.unlock_date + 1.day) : Time.now.utc.midnight
      num.times do
        UnlockCode.create do |code|
          code.unlock_date = date
          code.combination = generate_combination
        end
        date += 1.day
      end
    end
  
    def generate_combination
      rand(9999).to_s.rjust(4, rand(9).to_s)
    end
    
  end  
end

