module Rein
  module Constraint
    # This module defines methods for handling options command to several constraints.
    module Options
      def conditions_with_if(conditions, options = {})
        if options[:if].present?
          "NOT (#{options[:if]}) OR (#{conditions})"
        else
          conditions
        end
      end

      def constraint_name(table, attribute, options = {})
        options[:name].presence || "#{table}_#{attribute}"
      end
    end
  end
end
