class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :author, :polymorphic => true
  embedded_in :notable, :polymorphic => true
  
  field :header
  field :body
end
