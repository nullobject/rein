module Rein
  module Constraint
    # This module contains methods for defining presence constraints.
    module Presence
      include ActiveRecord::ConnectionAdapters::Quoting
      include Rein::Constraint::Options

      def add_presence_constraint(*args)
        reversible do |dir|
          dir.up { _add_presence_constraint(*args) }
          dir.down { _remove_presence_constraint(*args) }
        end
      end

      def remove_presence_constraint(*args)
        reversible do |dir|
          dir.up { _remove_presence_constraint(*args) }
          dir.down { _add_presence_constraint(*args) }
        end
      end

      private

      def _add_presence_constraint(table, attribute, options = {})
        name = constraint_name(table, attribute, options)
        conditions = conditions_with_if(
          "(#{attribute} IS NOT NULL) AND (#{attribute} !~ '^\\s*$')",
          options
        )
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_presence_constraint(table, attribute, options = {})
        name = constraint_name(table, attribute, options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
