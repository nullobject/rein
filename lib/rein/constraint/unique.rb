require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining unique constraints.
    module Unique
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_unique_constraint(*args)
        reversible do |dir|
          dir.up { _add_unique_constraint(*args) }
          dir.down { _remove_unique_constraint(*args) }
        end
      end

      def remove_unique_constraint(*args)
        reversible do |dir|
          dir.up { _remove_unique_constraint(*args) }
          dir.down { _add_unique_constraint(*args) }
        end
      end

      private

      def _add_unique_constraint(table, attributes, options = {})
        attributes = [attributes].flatten
        name = Util.constraint_name(table, attributes.join('_'), 'unique', options)
        table = Util.wrap_identifier(table)
        attributes = attributes.map { |attribute| Util.wrap_identifier(attribute) }
        initially = options[:deferred] ? 'DEFERRED' : 'IMMEDIATE'
        sql = "ALTER TABLE #{table} ADD CONSTRAINT #{name} UNIQUE (#{attributes.join(', ')})"
        sql << " DEFERRABLE INITIALLY #{initially}" unless options[:deferrable] == false
        execute(sql)
      end

      def _remove_unique_constraint(table, attributes, options = {})
        attributes = [attributes].flatten
        name = Util.constraint_name(table, attributes.join('_'), 'unique', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
