class Profile
  include Mongoid::Document
  default_scope asc(:name_first)
  
  field :name_first
  field :name_last
  field :bio
  
  index :name_first
  index :name_last
  
  def fullname
    "#{name_first} #{name_last}"
  end
  
  def self.retrieve user = OpenStruct.new(:admin? => false)
    all
  end
  
end
