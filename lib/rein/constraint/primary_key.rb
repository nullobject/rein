module Rein
  module Constraint
    # This module contains methods for defining primary key constraints.
    module PrimaryKey
      def add_primary_key(*args)
        reversible do |dir|
          dir.up { _add_primary_key(*args) }
          dir.down { _remove_primary_key(*args) }
        end
      end

      def remove_primary_key(*args)
        reversible do |dir|
          dir.up { _remove_primary_key(*args) }
          dir.down { _add_primary_key(*args) }
        end
      end

      private

      def _add_primary_key(table, options = {})
        attribute = (options[:column] || "id").to_sym
        execute("ALTER TABLE #{table} ADD PRIMARY KEY (#{attribute})")
      end

      def _remove_primary_key(table, options = {})
        attribute = (options[:column] || "id").to_sym
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{attribute}_pkey")
      end
    end
  end
end
