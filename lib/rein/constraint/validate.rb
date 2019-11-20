require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for validating constraints.
    module Validate
      def validate_table_constraint(*args)
        reversible do |dir|
          dir.up { _validate_table_constraint(*args) }
          dir.down do
            # No-op - it's safe to validate an already validated constraint
            # https://www.postgresql.org/docs/current/sql-altertable.html#SQL-ALTERTABLE-NOTES
            # "Nothing happens if the constraint is already marked valid."
          end
        end
      end

      private def _validate_table_constraint(table, constraint_name)
        execute("ALTER TABLE #{Util.wrap_identifier(table)} VALIDATE CONSTRAINT #{constraint_name}")
      end
    end
  end
end
