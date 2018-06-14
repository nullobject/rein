require 'active_support/inflector'
require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining check constraints.
    module Check
      def add_check_constraint(*args)
        reversible do |dir|
          dir.up do _add_check_constraint(*args) end
          dir.down { _remove_check_constraint(*args) }
        end
      end

      def remove_check_constraint(*args)
        reversible do |dir|
          dir.up do _remove_check_constraint(*args) end
          dir.down { _add_check_constraint(*args) }
        end
      end

      private

      def _add_check_constraint(table_name, predicate, options = {})
        raise 'Generic CHECK constraints must have a name' unless options[:name].present?
        name = Util.wrap_identifier(options[:name])
        sql = "ALTER TABLE #{Util.wrap_identifier(table_name)}"
        sql << " ADD CONSTRAINT #{name}"
        sql << " CHECK (#{predicate})"
        execute(sql)
      end

      def _remove_check_constraint(table_name, _predicate, options = {})
        raise 'Generic CHECK constraints must have a name' unless options[:name].present?
        name = Util.wrap_identifier(options[:name])
        execute("ALTER TABLE #{Util.wrap_identifier(table_name)} DROP CONSTRAINT #{name}")
      end
    end
  end
end
