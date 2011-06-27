class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :_type, :default => "standard"
  field :_payment_status, :default => "pending"
  
  validates_inclusion_of :_type, :in => %w{ premium standard guest }
  validates_inclusion_of :_payment_status, :in => %w{ pending processed }
end
