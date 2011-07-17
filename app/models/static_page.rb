class StaticPage
  include Mongoid::Document
  
  embeds_many :page_sections
  
  default_scope asc(:_pos)
  
  field :title
  field :_pos, :default => 0
  field :text
  
  def self.retrieve user = OpenStruct.new(:admin? => false)
    all
  end
  
end
