class UnlockCode
  include Mongoid::Document
  
  include Searchable
  include Sortable
  
  scope :expired, where(:unlock_date.lt => Time.now.midnight)
  scope :future, where(:unlock_date.gt => Time.now.midnight)
  default_scope where(:unlock_date.gt => (Time.now.midnight - 1.day)).desc(:unlock_date).limit(5)
  
  field :unlock_date
  field :combination
  
  index :unlock_date
  
  validates_presence_of :unlock_date, :combination
  validates_uniqueness_of :unlock_date
  validates_format_of :combination, :with => /[\d]{4}/
  
  class << self
    def get_current
      first(:conditions => {:unlock_date.gte => Time.now.midnight})
    end
  
    def generate num = 1
      members = UnlockCode.desc(:unlock_date)
      date = members.any? ? (members.first.date + 1.day) : Time.now.midnight
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

