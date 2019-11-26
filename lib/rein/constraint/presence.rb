require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining presence constraints.
    module Presence
      include ActiveRecord::ConnectionAdapters::Quoting

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
        name = Util.constraint_name(table, attribute, 'presence', options)
        table = Util.wrap_identifier(table)
        attribute = Util.wrap_identifier(attribute)
        conditions = Util.conditions_with_if(
          "(#{attribute} IS NOT NULL) AND (#{attribute} !~ '^\\s*$')",
          options
        )
        sql = "ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})"
        execute(Util.add_not_valid_suffix_if_required(sql, options))
      end

      def _remove_presence_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'presence', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
