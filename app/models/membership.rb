class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  
  field :_type, :default => "basic"
  field :_payment_status, :default => "pending"
  
  validates_inclusion_of  :_type, :in => %w{ premium basic guest }
  validates_inclusion_of  :_payment_status, :in => %w{ pending processed }
  validates_uniqueness_of :_type, :scope => :user_id
  
  def self.retrieve user = OpenStruct.new(:admin? => false)
    all
  end
end
