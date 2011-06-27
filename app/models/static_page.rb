class StaticPage
  include Mongoid::Document
  
  embeds_many :page_sections
  
  default_scope asc(:_pos)
  
  field :title
  field :_pos, :default => 0
  field :text
  
  def sections
    page_sections.asc(:_pos)
  end
  
end

class PageSection
  include Mongoid::Document
  
  embedded_in :static_page
  
  default_scope asc(:_pos)
  
  field :title
  field :_pos
  field :text
end
