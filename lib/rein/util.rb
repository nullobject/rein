module Rein
  module Constraint
    # The {Util} module provides utility methods for handling options.
    module Util
      def self.conditions_with_if(conditions, options = {})
        if options[:if].present?
          "NOT (#{options[:if]}) OR (#{conditions})"
        else
          conditions
        end
      end

      def self.constraint_name(table, attribute, suffix, options = {})
        options[:name].presence || "#{table}_#{attribute}_#{suffix}"
      end

      def self.attribute_name(attribute)
        "\"#{attribute}\""
      end
    end
  end
end
