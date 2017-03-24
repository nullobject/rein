module Rein
  module Constraint
    # This module contains methods for defining presence constraints.
    module Presence
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_presence_constraint(table, attribute, options = {})
        name       = "#{table}_#{attribute}"
        conditions = "#{attribute} !~ '^\\s*$'"
        if options[:if].present?
          conditions = "NOT (#{options[:if]}) OR (#{conditions})"
        end
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end
    end
  end
end
