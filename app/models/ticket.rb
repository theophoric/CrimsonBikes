class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :bike
  belongs_to :user
  
  embeds_many :comments, :as => :commentable
  
  field :subject
  field :description
  field :_priority_level, :default => 5
  field :_status, :default => "open"
  
  validates_inclusion_of :_priority_level, :in => 1..5
  validates_inclusion_of :_status, :in => %w{ open in_progress closed }
  
  
end
