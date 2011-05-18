class Bike
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  
  belongs_to :location
  
  embeds_many :notes, :as => :notable
  
  field :name
  field :_status
  field :_identifier
  
  field :location
  
  
end
