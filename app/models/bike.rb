class Bike
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :location
  
  embeds_many :notes, :as => :notable
  
  field :name
  field :_status
  field :_identifier
  
  
end
