module Rein
  module Constraint
    # This module contains methods for defining null constraints.
    module Null
      include ActiveRecord::ConnectionAdapters::Quoting
      include Rein::Constraint::Options

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
        name = constraint_name(table, attribute, options)
        conditions = conditions_with_if("#{attribute} IS NOT NULL", options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_null_constraint(table, attribute, options = {})
        name = constraint_name(table, attribute, options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
