class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Searchable
  include Sortable
  
  embedded_in :user
  
  # field :level, :default => "guest"
  field :active, :type => Boolean, :default => false
  field :activated_at, :type => Time
  field :expiration_date, :default => Date.new(2011,12,22).to_time.utc
  
  # validates_inclusion_of  :level, :in => %w{ full half trial guest }
  
  def activate params = {}
    update_attributes(params.merge({:active => true, :activeated_at => Time.zone.now.utc}))
  end
  
end