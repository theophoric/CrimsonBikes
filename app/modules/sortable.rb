module Sortable
  def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def sort_collection direction, field = nil
        if field
          unscoped.method(direction).call(field.to_sym)
        else
          all
        end
      end
    end
end