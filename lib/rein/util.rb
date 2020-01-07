module Rein
  # The {Util} module provides utility methods for handling options.
  module Util
    # Returns a new string with the suffix appended if required
    def self.add_not_valid_suffix_if_required(sql, options)
      suffix = options[:validate] == false ? ' NOT VALID' : ''
      "#{sql}#{suffix}"
    end

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

    def self.wrap_identifier(attribute)
      if /^".*"$/.match?(attribute)
        attribute
      else
        "\"#{attribute}\""
      end
    end
  end
end
