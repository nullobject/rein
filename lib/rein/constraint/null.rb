require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining null constraints.
    module Null
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_null_constraint(*args)
        reversible do |dir|
          dir.up { _add_null_constraint(*args) }
          dir.down { _remove_null_constraint(*args) }
        end
      end

      def remove_null_constraint(*args)
        reversible do |dir|
          dir.up { _remove_null_constraint(*args) }
          dir.down { _add_null_constraint(*args) }
        end
      end

      private

      def _add_null_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'null', options)
        table = Util.wrap_identifier(table)
        attribute = Util.wrap_identifier(attribute)
        conditions = Util.conditions_with_if("#{attribute} IS NOT NULL", options)
        execute(
          Util.add_not_valid_suffix_if_required(
            "ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})",
            options
          )
        )
      end

      def _remove_null_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'null', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
