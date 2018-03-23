require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining presence constraints.
    module Presence
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_presence_constraint(*args)
        reversible do |dir|
          dir.up do _add_presence_constraint(*args) end
          dir.down { _remove_presence_constraint(*args) }
        end
      end

      def remove_presence_constraint(*args)
        reversible do |dir|
          dir.up do _remove_presence_constraint(*args) end
          dir.down { _add_presence_constraint(*args) }
        end
      end

      private

      def _add_presence_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'presence', options)
        attribute = Rein::Util.wrap_identifier(attribute)
        conditions = Rein::Util.conditions_with_if(
          "(#{attribute} IS NOT NULL) AND (#{attribute} !~ '^\\s*$')",
          options
        )
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_presence_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'presence', options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
