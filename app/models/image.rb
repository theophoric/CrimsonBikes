class Image
  include Mongoid::Document
  
  mount_uploader :source, ImageUploader
  
  belongs_to :imageable, :polymorphic => true
  
  field :main, :default => false
  
end
