class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  
  embedded_in :commentable, :polymorphic => true
  
  field :body
  
  validates_presence_of :body
  
end
