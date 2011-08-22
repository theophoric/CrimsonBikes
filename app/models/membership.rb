class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Searchable
  include Sortable
  
  embedded_in :user
  
  field :level, :default => "guest"
  
  validates_inclusion_of  :level, :in => %w{ premium basic trial guest }
  validates_uniqueness_of :level, :scope => :user_id
  
end
