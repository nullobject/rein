module Rein
  module Constraint
    # This module contains methods for defining presence constraints.
    module Presence
      include ActiveRecord::ConnectionAdapters::Quoting
      include Rein::Constraint::Options

      def add_presence_constraint(table, attribute, options = {})
        name = "#{table}_#{attribute}"
        conditions = conditions_with_if("#{attribute} !~ '^\\s*$'", options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def remove_presence_constraint(table, attribute)
        name = "#{table}_#{attribute}"
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
