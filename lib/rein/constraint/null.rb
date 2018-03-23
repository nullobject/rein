require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining null constraints.
    module Null
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_null_constraint(*args)
        reversible do |dir|
          dir.up do _add_null_constraint(*args) end
          dir.down { _remove_null_constraint(*args) }
        end
      end

      def remove_null_constraint(*args)
        reversible do |dir|
          dir.up do _remove_null_constraint(*args) end
          dir.down { _add_null_constraint(*args) }
        end
      end

      private

      def _add_null_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'null', options)
        attribute = Rein::Util.wrap_identifier(attribute)
        conditions = Rein::Util.conditions_with_if("#{attribute} IS NOT NULL", options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_null_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'null', options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
