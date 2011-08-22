class StaticPage
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Sortable
  include Searchable
  
  embeds_many :page_sections
  
  after_update :reindex
  after_create :reindex
  after_destroy :reindex
  
  default_scope asc(:_pos)
  
  field :title
  field :_pos, :default => 0
  field :text
  
  class << self
    def reindex
      unscoped.asc(:_pos).each_with_index{|page, index| page.update_attribute(:_pos, (index + 1))}
    end
  end
  
end
