require 'rubygems'

module CbTime
  class << self
    def now
      Time.zone.now.utc
    end
    def today
      Time.zone.now.midnight.utc
    end
    def tomorrow
      today + 1.day
    end
    def yesterday
      today - 1.day
    end
  end
end