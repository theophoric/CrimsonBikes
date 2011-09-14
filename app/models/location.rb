class Location
  include Mongoid::Document
  
  include Sortable

  mount_uploader :image, ImageUploader
  
  has_many :bikes
  has_many :images, :as => :imageable
  
  embeds_many :descriptions, :as => :describeable
  
  accepts_nested_attributes_for :images
  
  field :name
  field :address
  field :description, :default => ""
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # CLASS METHODS
  class << self
    def retrieve user = OpenStruct.new(:admin? => false)
      all
    end
    def search query = nil
      if query
        regex_query = Regexp.new(query, true)
        any_of({:name => regex_query}, {:address => regex_query})
      else
        all
      end
    end
  end
  
end
