module Searchable
  def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def retrieve user = OpenStruct.new(:admin? => false)
        all
      end
      def search_collection query = nil
        all
      end
    end
end