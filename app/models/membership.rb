class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Searchable
  include Sortable
  
  belongs_to :user
  
  field :level, :default => "basic"
  field :_payment_status, :default => "pending"
  
  validates_inclusion_of  :level, :in => %w{ premium basic guest }
  validates_inclusion_of  :_payment_status, :in => %w{ pending processed }
  validates_uniqueness_of :level, :scope => :user_id
  
  
end
