class Location
  include Mongoid::Document

  mount_uploader :image, ImageUploader
  
  has_many :bikes
  has_many :images, :as => :imageable
  
  embeds_many :descriptions, :as => :describeable
  
  accepts_nested_attributes_for :images
  
  field :name
  field :address
  
  validates_presence_of :name
  
  # CLASS METHODS
  def self.retrieve user
    all
  end
  
end
